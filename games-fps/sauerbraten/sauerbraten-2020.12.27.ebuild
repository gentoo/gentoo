# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop flag-o-matic toolchain-funcs wrapper xdg

DESCRIPTION="Sauerbraten is a FOSS game engine (Cube 2) with freeware game data (Sauerbraten)"
HOMEPAGE="http://sauerbraten.org/"
SRC_URI="mirror://sourceforge/sauerbraten/sauerbraten/2020_11_29/sauerbraten_${PV//./_}_linux.tar.bz2"
S="${WORKDIR}"/${PN}

LICENSE="ZLIB freedist"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug dedicated server"

DEPEND="
	>=net-libs/enet-1.3.6:1.3
	sys-libs/zlib
	!dedicated? (
		media-libs/libsdl2[X,opengl]
		media-libs/sdl2-image
		media-libs/sdl2-mixer
		virtual/opengl
		virtual/glu
		x11-libs/libX11
	)
"
RDEPEND="
	${DEPEND}
	acct-group/sauerbraten
	dedicated? ( acct-user/sauerbraten )
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	# Respect CXXFLAGS, LDFLAGS
	"${FILESDIR}"/${PN}-2020.12.27-respect-FLAGS-don-t-strip-symbols.patch

	# Patch Makefile to use system enet instead of bundled
	"${FILESDIR}"/${PN}-2020.12.27-unbundle-enet.patch

	# Don't use freetype-config, it's obsolete
	"${FILESDIR}"/${PN}-2020.12.27-use-pkg-config-for-freetype2.patch
)

src_prepare() {
	rm -rf sauerbraten_unix bin_unix src/{include,lib,vcpp} || die

	default

	# Fix links so they point to the correct directory
	sed -i -e 's:docs/::' README.html || die
}

src_compile() {
	tc-export CXX PKG_CONFIG

	if use debug ; then
		append-cppflags -D_DEBUG
	fi

	emake -C src \
		master \
		$(usex dedicated "server" "$(usex server "server client" "client")")
}

src_install() {
	local LIBEXECDIR="/usr/lib"
	local DATADIR="/usr/share/${PN}"
	local STATEDIR="/var/lib/${PN}"

	if ! use dedicated ; then
		# Install the game data
		insinto "${DATADIR}"
		doins -r data packages

		# Install the client executable
		exeinto "${LIBEXECDIR}"
		doexe src/sauer_client

		# Install the client wrapper
		make_wrapper "${PN}-client" "${LIBEXECDIR}/sauer_client -q\$HOME/.${PN} -r" "${DATADIR}"

		# Create menu entry
		newicon -s 256 data/cube.png ${PN}.png
		make_desktop_entry "${PN}-client" "Cube 2: Sauerbraten"
	fi

	# Install the server config files
	insinto "${STATEDIR}"
	doins server-init.cfg

	# Install the server executables
	exeinto "${LIBEXECDIR}"
	doexe src/sauer_master

	if use dedicated || use server ; then
		doexe src/sauer_server
	fi

	make_wrapper "${PN}-server" \
		"${LIBEXECDIR}/sauer_server -k${DATADIR} -q${STATEDIR}"
	make_wrapper "${PN}-master" \
		"${LIBEXECDIR}/sauer_master ${STATEDIR}"

	# Install the server init script
	cp "${FILESDIR}"/${PN}.init "${T}" || die
	sed -i \
		-e "s:%SYSCONFDIR%:${STATEDIR}:g" \
		-e "s:%LIBEXECDIR%:${LIBEXECDIR}:g" \
		-e "s:%/var/lib/%:/var/run:g" \
		"${T}"/${PN}.init || die

	newinitd "${T}"/${PN}.init ${PN}
	cp "${FILESDIR}"/${PN}.conf "${T}" || die
	sed -i \
		-e "s:%SYSCONFDIR%:${STATEDIR}:g" \
		-e "s:%LIBEXECDIR%:${LIBEXECDIR}:g" \
		-e "s:%GAMES_USER_DED%:sauerbraten:g" \
		-e "s:%GAMES_GROUP%:sauerbraten:g" \
		"${T}"/${PN}.conf || die
	newconfd "${T}"/${PN}.conf ${PN}

	dodoc src/*.txt docs/dev/*.txt

	docinto html
	dodoc -r README.html docs/*
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "If you plan to use map editor feature copy all map data from ${DATADIR}"
	elog "to corresponding folder in your HOME/.${PN}"
}

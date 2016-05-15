# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic gnome2-utils games

EDITION="collect_edition"
DESCRIPTION="Cube 2: Sauerbraten is an open source game engine (Cube 2) with freeware game data (Sauerbraten)"
HOMEPAGE="http://sauerbraten.org/"
SRC_URI="mirror://sourceforge/sauerbraten/sauerbraten/2013_02_03/sauerbraten_${PV//./_}_${EDITION}_linux.tar.bz2"

LICENSE="ZLIB freedist"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug dedicated server"

RDEPEND="
	sys-libs/zlib
	>=net-libs/enet-1.3.6:1.3
	!dedicated? (
		media-libs/libsdl[X,opengl]
		media-libs/sdl-mixer[vorbis]
		media-libs/sdl-image[png,jpeg]
		virtual/opengl
		virtual/glu
		x11-libs/libX11 )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	ecvs_clean
	rm -rf sauerbraten_unix bin_unix src/{include,lib,vcpp}

	# Patch makefile to use system enet instead of bundled
	# respect CXXFLAGS, LDFLAGS
	epatch "${FILESDIR}"/${P}-{system-enet,QA}.patch

	# Fix links so they point to the correct directory
	sed -i -e 's:docs/::' README.html || die
}

src_compile() {
	use debug && append-cppflags -D_DEBUG
	emake -C src master $(usex dedicated "server" "$(usex server "server client" "client")")
}

src_install() {
	local LIBEXECDIR="${GAMES_PREFIX}/lib"
	local DATADIR="${GAMES_DATADIR}/${PN}"
	local STATEDIR="${GAMES_STATEDIR}/${PN}"

	if ! use dedicated ; then
		# Install the game data
		insinto "${DATADIR}"
		doins -r data packages

		# Install the client executable
		exeinto "${LIBEXECDIR}"
		doexe src/sauer_client

		# Install the client wrapper
		games_make_wrapper "${PN}-client" "${LIBEXECDIR}/sauer_client -q\$HOME/.${PN} -r" "${DATADIR}"

		# Create menu entry
		newicon -s 256 data/cube.png ${PN}.png
		make_desktop_entry "${PN}-client" "Cube 2: Sauerbraten"
	fi

	# Install the server config files
	insinto "${STATEDIR}"
	doins "server-init.cfg"

	# Install the server executables
	exeinto "${LIBEXECDIR}"
	doexe src/sauer_master
	use dedicated || use server && doexe src/sauer_server

	games_make_wrapper "${PN}-server" \
		"${LIBEXECDIR}/sauer_server -k${DATADIR} -q${STATEDIR}"
	games_make_wrapper "${PN}-master" \
		"${LIBEXECDIR}/sauer_master ${STATEDIR}"

	# Install the server init script
	keepdir "${GAMES_STATEDIR}/run/${PN}"
	cp "${FILESDIR}"/${PN}.init "${T}" || die
	sed -i \
		-e "s:%SYSCONFDIR%:${STATEDIR}:g" \
		-e "s:%LIBEXECDIR%:${LIBEXECDIR}:g" \
		-e "s:%GAMES_STATEDIR%:${GAMES_STATEDIR}:g" \
		"${T}"/${PN}.init || die
	newinitd "${T}"/${PN}.init ${PN}
	cp "${FILESDIR}"/${PN}.conf "${T}" || die
	sed -i \
		-e "s:%SYSCONFDIR%:${STATEDIR}:g" \
		-e "s:%LIBEXECDIR%:${LIBEXECDIR}:g" \
		-e "s:%GAMES_USER_DED%:${GAMES_USER_DED}:g" \
		-e "s:%GAMES_GROUP%:${GAMES_GROUP}:g" \
		"${T}"/${PN}.conf || die
	newconfd "${T}"/${PN}.conf ${PN}

	dodoc src/*.txt docs/dev/*.txt
	dohtml -r README.html docs/*

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update

	elog "If you plan to use map editor feature copy all map data from ${DATADIR}"
	elog "to corresponding folder in your HOME/.${PN}"
}

pkg_postrm() {
	gnome2_icon_cache_update
}

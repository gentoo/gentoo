# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop flag-o-matic toolchain-funcs xdg

# 2.5.0 requires several patches
COMMIT="8b4533e85fdc0665889ff285e1521432084ee784"

# UFO:AI v2.5.0 was uploaded to SourceForge as 2.5
DIST_VERSION=$(ver_cut 1-2)

# Install game data here
DATADIR="/usr/share/${PN}"

DESCRIPTION="UFO: Alien Invasion - X-COM inspired strategy game"
HOMEPAGE="https://ufoai.org/"
SRC_URI="
	https://dev.gentoo.org/~chewi/distfiles/${PN}-code-${COMMIT}.zip
	mirror://sourceforge/${PN}/${PN}-${DIST_VERSION}-data.tar
	editor? ( mirror://sourceforge/${PN}/${PN}-${DIST_VERSION}-mappack.tar.bz2 )
"

# https://ufoai.org/licenses/
LICENSE="GPL-2 GPL-3 public-domain CC-BY-3.0 CC-BY-SA-3.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+client cpu_flags_x86_sse debug editor server"
REQUIRED_USE="|| ( client editor server )"

RDEPEND="
	dev-libs/mxml
	net-misc/curl
	sys-libs/zlib

	client? (
		media-libs/libogg
		media-libs/libpng:0=
		media-libs/libsdl2[joystick,opengl,sound,threads,video]
		media-libs/libtheora
		media-libs/libvorbis
		media-libs/sdl2-mixer
		media-libs/sdl2-ttf
		media-libs/xvid
		virtual/jpeg:0
		virtual/opengl
	)

	editor? (
		dev-libs/glib:2
		dev-libs/libxml2:2
		media-libs/libogg
		media-libs/libpng:0=
		media-libs/libsdl2[joystick,opengl,sound,threads,video]
		media-libs/libvorbis
		media-libs/openal
		virtual/glu
		virtual/jpeg:0
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:2
		x11-libs/gtkglext
		x11-libs/gtksourceview:2.0
	)

	server? (
		media-libs/libsdl2[threads]
	)
"

DEPEND="
	${RDEPEND}
	app-arch/unzip
	sys-devel/gettext
	virtual/pkgconfig
"

S="${WORKDIR}/${PN}-code-${COMMIT}"

PATCHES=(
	"${FILESDIR}"/${P}-install.patch
	"${FILESDIR}"/${P}-mxml3.patch
)

src_unpack() {
	use editor && unpack ${PN}-${DIST_VERSION}-mappack.tar.bz2
	unpack ${PN}-code-${COMMIT}.zip
	cd "${S}" || die
	unpack ${PN}-${DIST_VERSION}-data.tar
}

src_prepare() {
	default

	# Make the build system a bit happier, will be fixed upstream
	mkdir -p base/{maps,models} contrib/installer/mojosetup/scripts || die

	# Remove bundled mxml
	rm -r src/libs/mxml/ || die
}

src_configure() {
	# Avoid noise, will be present in 2.6
	append-cxxflags -Wno-expansion-to-defined

	# The configure script of UFO:AI is hand crafted and a bit special
	# econf does not work: "invalid option --build=x86_64-pc-linux-gnu"
	local config=(
		--prefix="${EPREFIX}"/usr
		--datadir="${EPREFIX}${DATADIR}"
		--libdir="${EPREFIX}"/usr/$(get_libdir)/${PN}
		--localedir="${EPREFIX}"/usr/share/locale
		--disable-dependency-tracking
		--disable-paranoid
		--disable-memory
		--disable-testall
		--disable-ufomodel
		--disable-ufoslicer
		$(use_enable cpu_flags_x86_sse sse)
		$(use_enable !debug release)
		$(use_enable server ufoded)
		$(use_enable client ufo)
		$(use_enable editor uforadiant)
		$(use_enable editor ufo2map)
	)

	if use client || use server; then
		config+=( --enable-game )
	else
		config+=( --disable-game )
	fi

	echo ./configure "${config[@]}"

	CC=$(tc-getCC) CXX=$(tc-getCXX) \
	  ./configure "${config[@]}" || die "configure failed"
}

src_compile() {
	emake all lang Q=
}

src_install() {
	newicon -s 32 src/ports/linux/ufo.png ${PN}.png
	emake install Q= DESTDIR="${D}"

	if use client; then
		doman debian/ufo.6
		make_desktop_entry ufo "UFO: Alien Invasion" ${PN}
	fi

	if use server; then
		doman debian/ufoded.6
		make_desktop_entry ufoded "UFO: Alien Invasion Server" ${PN} "Game;StrategyGame" "Terminal=true"
	fi

	if use editor; then
		doman debian/ufo{2map,radiant}.6
		make_desktop_entry uforadiant "UFO: Alien Invasion Map editor" ${PN}

		# Install map editor data (without the binary)
		rm radiant/uforadiant || die
		insinto "${DATADIR}"
		doins -r radiant

		# Install map sources
		insinto "${DATADIR}"/base/maps
		doins -r "${WORKDIR}"/${PN}-${DIST_VERSION}-mappack/*
	fi
}

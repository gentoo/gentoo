# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake java-pkg-2 desktop flag-o-matic

MY_PV="${PV}-r8786"

DESCRIPTION="Fork of the famous open racing car simulator TORCS"
HOMEPAGE="http://www.speed-dreams.org/"
SRC_URI="
	https://downloads.sourceforge.net/speed-dreams/${PN}-src-base-${MY_PV}.tar.xz
	https://downloads.sourceforge.net/speed-dreams/${PN}-src-hq-cars-and-tracks-${MY_PV}.tar.xz
	https://downloads.sourceforge.net/speed-dreams/${PN}-src-more-hq-cars-and-tracks-${MY_PV}.tar.xz
	https://downloads.sourceforge.net/speed-dreams/${PN}-src-wip-cars-and-tracks-${MY_PV}.tar.xz"

LICENSE="GPL-2+ BitstreamVera CC0-1.0 Free-Art-1.2 OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug osggraph webstats"

COMMON_DEPEND="
	dev-games/freesolid
	dev-libs/expat
	media-libs/libjpeg-turbo:0=
	media-libs/libpng:=
	media-libs/libsdl2[X,haptic,opengl,joystick,video]
	media-libs/sdl2-mixer
	media-libs/openal
	media-libs/plib
	net-libs/enet:1.3
	sys-libs/zlib:=
	net-misc/curl
	virtual/glu
	virtual/opengl
	osggraph? ( dev-games/openscenegraph:=[png] )
"
DEPEND="
	${COMMON_DEPEND}
	>=virtual/jdk-11:*
	x11-base/xorg-proto"
RDEPEND="
	${COMMON_DEPEND}
	>=virtual/jre-1.8:*
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.2.3_rc1-xmlversion-rpath.patch
)

src_unpack() {
	mkdir "${S}" || die
	cd "${S}"
	default
}

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	append-cppflags -I. #806980

	local mycmakeargs=(
		-DCMAKE_BUILD_WITH_INSTALL_RPATH=yes # see xmlversion-rpath patch
		-DOPTION_3RDPARTY_SOLID=yes
		-DOPTION_OFFICIAL_ONLY=yes
		-DOPTION_OSGGRAPH=$(usex osggraph)
		-DOPTION_TRACE_LEVEL=$(usex debug 5 3)
		-DOPTION_WEBSERVER=$(usex webstats)
		-DOpenGL_GL_PREFERENCE=LEGACY # legacy needed for gl*ARB symbols
		-DSD_BINDIR="${EPREFIX}"/usr/bin
		-DSD_DATADIR="${EPREFIX}"/usr/share/${PN}-2
		-DSD_LIBDIR="${EPREFIX}"/usr/$(get_libdir)/${PN}-2

		# These features currently lack official support and portions
		# of the required code is missing in release tarballs.
		# Check if these directories exist on a version bump.
		#-DOPTION_3RDPARTY_SQLITE3=yes # src/modules/simu/simureplay/
		#-DOPTION_CLIENT_SERVER=yes # src/modules/csnetworking/
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	local HTML_DOCS=( doc/userman/. )
	cmake_src_install

	newicon data/data/icons/icon.png ${PN}-2.png
	make_desktop_entry ${PN}-2 "Speed Dreams 2" ${PN}-2
}

pkg_postinst() {
	# Issue reproduced in testing, warn in case it's widespread.
	elog "If you experience freezes in menus, try to disable menu music in options."
	elog "See: https://sourceforge.net/p/speed-dreams/tickets/973/"
}

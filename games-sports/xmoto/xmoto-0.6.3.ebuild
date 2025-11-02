# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} )

inherit cmake lua-single optfeature

DESCRIPTION="A challenging 2D motocross platform game, where physics play an important role"
HOMEPAGE="https://xmoto.org"
SRC_URI="https://github.com/xmoto/xmoto/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="double-precision +nls +system-ode"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	app-arch/bzip2
	dev-db/sqlite:3
	dev-libs/libxdg-basedir
	dev-libs/libxml2:=
	media-fonts/dejavu
	media-libs/glu
	media-libs/libglvnd
	media-libs/libjpeg-turbo:=
	media-libs/libpng:0=
	media-libs/libsdl2[joystick,opengl]
	media-libs/sdl2-mixer[vorbis]
	media-libs/sdl2-net
	media-libs/sdl2-ttf
	net-misc/curl
	sys-libs/zlib:=
	nls? ( virtual/libintl )
	system-ode? ( <dev-games/ode-0.16[double-precision=] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/xz-utils
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.6.3-system_ode.patch
	"${FILESDIR}"/${PN}-0.6.3-find_opengl.patch
	"${FILESDIR}"/${PN}-0.6.3-missing_includes.patch
)

src_prepare() {
	# fix fonts path
	sed -e 's:ASIAN_TTF_FILE=.*)$:ASIAN_TTF_FILE=\\\"'"${EPREFIX}"'/usr/share/fonts/arphicfonts/bkai00mp.ttf\\\"):' \
		-i src/CMakeLists.txt || die
	sed -e 's:Textures/Fonts/DejaVu:'"${EPREFIX}"'/usr/share/fonts/dejavu/DejaVu:' \
		-i src/drawlib/DrawLib.cpp || die

	sed -e "/add_subdirectory.*\(bzip2\|lua\|xdgbasedir\)/d" -i src/CMakeLists.txt || die
	rm -r vendor/{bzip2,lua,xdgbasedir} || die

	if use system-ode; then
		rm -r vendor/{ode,libccd} || die
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DLUA_INCLUDE_DIR="$(lua_get_include_dir)"
		-DPREFER_SYSTEM_ODE=$(usex system-ode)
		-DUSE_GETTEXT=$(usex nls)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	# remove bundled fonts
	rm -f "${ED}/usr/share/xmoto"/Textures/Fonts/DejaVuSans{Mono,}.ttf || die
}

pkg_postinst() {
	optfeature "Chinese font support" media-fonts/arphicfonts
}

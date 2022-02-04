# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} )

inherit cmake lua-single

DESCRIPTION="A challenging 2D motocross platform game, where physics play an important role"
HOMEPAGE="https://xmoto.tuxfamily.org"
SRC_URI="https://github.com/xmoto/xmoto/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="double-precision +nls"

REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="app-arch/bzip2
	dev-db/sqlite:3
	dev-games/ode[double-precision=]
	${LUA_DEPS}
	dev-libs/libxdg-basedir
	dev-libs/libxml2
	media-fonts/dejavu
	media-libs/libpng:0=
	media-libs/libsdl[joystick,opengl]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-net
	media-libs/sdl-ttf
	net-misc/curl
	sys-libs/zlib:=
	virtual/jpeg:0
	virtual/glu
	virtual/opengl
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/xz-utils
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}/${P}_lua_deprecated.patch"
	"${FILESDIR}/${PN}-0.6.1_cmake_lua_version.patch"
)

src_prepare() {
	sed -e "/^Icon/s/.xpm//" -i extra/xmoto.desktop || die
	sed -e "/add_subdirectory.*\(bzip2\|libccd\|lua\|ode\|xdgbasedir\)/d" -i src/CMakeLists.txt || die
	rm -rf vendor/{bzip2,lua,ode,xdgbasedir} || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DUSE_GETTEXT=$(usex nls)
		-DOpenGL_GL_PREFERENCE=GLVND
		-DLUA_VERSION=$(lua_get_version)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	rm -f "${ED}/usr/share/xmoto"/Textures/Fonts/DejaVuSans{Mono,}.ttf || die
	dosym ../../../fonts/dejavu/DejaVuSans.ttf /usr/share/xmoto/Textures/Fonts/DejaVuSans.ttf
	dosym ../../../fonts/dejavu/DejaVuSansMono.ttf /usr/share/xmoto/Textures/Fonts/DejaVuSansMono.ttf
}

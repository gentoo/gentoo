# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} )

inherit cmake lua-single xdg

MY_PN="CorsixTH"
MY_PV="$(ver_rs 2 -)"

DESCRIPTION="Open source clone of Theme Hospital"
HOMEPAGE="https://corsixth.com"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc +midi +sound +truetype +videos"

REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="${LUA_DEPS}
	$(lua_gen_cond_dep '
		>=dev-lua/luafilesystem-1.5[${LUA_USEDEP}]
		>=dev-lua/lpeg-0.9[${LUA_USEDEP}]
		>=dev-lua/luasocket-3.0_rc1-r4[${LUA_USEDEP}]
	')
	media-libs/libsdl2[opengl,video]
	sound? ( media-libs/sdl2-mixer[midi?] )
	truetype? ( >=media-libs/freetype-2.5.3:2 )
	videos? ( >=media-video/ffmpeg-2.2.3:0= )
"

DEPEND="${RDEPEND}"

# Technically, build-time generation of documentation could use any version
# of Lua (or to be precise: if in src_configure cmake has been told to use
# LuaJIT documentation generation looks for LuaJIT, otherwise any
# dev-lang/lua slot will do; see the first few lines of the bundled file
# CMake/GenerateDoc.cmake for details) - but since dev-lang/lua conflicts
# with the other slots of same, try to keep the deptree sane until we get
# rid of unslotted Lua.
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-doc/doxygen[dot]
		${LUA_DEPS}
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.64-cmake_lua_detection.patch
)

S="${WORKDIR}/${MY_PN}-${MY_PV}"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DLUA_VERSION=$(lua_get_version)
		-DWITH_AUDIO=$(usex sound)
		-DWITH_FREETYPE2=$(usex truetype)
		-DWITH_MOVIES=$(usex videos)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_src_compile doc
}

src_install() {
	cmake_src_install
	dodoc {changelog,CONTRIBUTING}.txt

	docinto html
	use doc && dodoc -r "${BUILD_DIR}"/doc/*
}

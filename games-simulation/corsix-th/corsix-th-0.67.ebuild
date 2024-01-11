# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} )

inherit cmake lua-single xdg

MY_PN="CorsixTH"
MY_PV="${PV/_/-}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Open source clone of Theme Hospital"
HOMEPAGE="https://corsixth.com"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
if [[ ${PV} != *_beta* && ${PV} != *_rc* ]] ; then
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
fi
IUSE="doc +midi +sound tools +truetype +videos"

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

# Although the docs could potentially be built with nearly any Lua version,
# we need to ensure the necessary Lua modules are installed, so pin to the
# same single version as runtime.
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-text/doxygen[dot]
		${LUA_DEPS}
		$(lua_gen_cond_dep '
			>=dev-lua/luafilesystem-1.5[${LUA_USEDEP}]
			>=dev-lua/lpeg-0.9[${LUA_USEDEP}]
		')
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.67-cmake_lua_detection.patch
)

src_configure() {
	local mycmakeargs=(
		-DLUA_VERSION=$(lua_get_version)
		-DBUILD_TOOLS=$(usex tools)
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
	dodoc changelog.txt CONTRIBUTING.md

	docinto html
	use doc && dodoc -r "${BUILD_DIR}"/doc/*
}

# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit cmake edo lua-single xdg

MY_PN="CorsixTH"
MY_PV="${PV/_/-}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Open source clone of Theme Hospital"
HOMEPAGE="https://corsixth.com"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/${MY_PN}/${MY_PN}"
	inherit git-r3
else
	SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${MY_P}"

	if [[ ${PV} != *_beta* && ${PV} != *_rc* ]] ; then
		KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
	fi
fi

LICENSE="MIT"
SLOT="0"
IUSE="doc +midi test tools +videos"
RESTRICT="!test? ( test )"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	$(lua_gen_cond_dep '
		>=dev-lua/luafilesystem-1.5[${LUA_USEDEP}]
		>=dev-lua/lpeg-0.9[${LUA_USEDEP}]
		>=dev-lua/luasocket-3.0_rc1-r4[${LUA_USEDEP}]
	')
	media-libs/libsdl2[opengl,video]
	media-libs/libpng:=
	>=media-libs/freetype-2.5.3:2
	media-libs/sdl2-mixer[midi?]
	virtual/zlib:=
	midi? ( media-libs/rtmidi )
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
	test? (
		>=dev-cpp/catch-3:0
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.67-cmake_lua_detection.patch
)

lua_enable_tests busted

src_configure() {
	local mycmakeargs=(
		-DBUILD_TOOLS=$(usex tools)
		-DENABLE_UNIT_TESTS=$(usex test)
		-DWITH_MIDI_DEVICE=$(usex midi)
		-DWITH_MOVIES=$(usex videos)
		-DWITH_UPDATE_CHECK=OFF

		-DFETCH_CATCH2=OFF
		-DFETCH_SOUNDFONT=OFF
		-DFETCH_UNICODE_FONT=OFF
	)

	if use lua_single_target_luajit ; then
		mycmakeargs+=(
			-DLUA_VERSION=5.1
			-DLUA_LIBRARY=$(lua_get_shared_lib)
			-DWITH_LUAJIT=ON
		)
	else
		mycmakeargs+=(
			-DLUA_VERSION=$(lua_get_version)
		)
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_src_compile doc
}

src_test() {
	# https://github.com/CorsixTH/CorsixTH/blob/master/.github/workflows/Linux.yml#L88
	# C++ tests
	BUILD_DIR="${BUILD_DIR}"/CorsixTH cmake_src_test

	# Lua tests
	# vip_spec.lua fails with luajit
	edo busted \
		--lua="${ELUA}" \
		--output="TAP" \
		--verbose \
		--directory=CorsixTH/Luatest \
		--filter-out='VIP.*rating'
}

src_install() {
	cmake_src_install
	dodoc changelog.txt CONTRIBUTING.md

	docinto html
	use doc && dodoc -r "${BUILD_DIR}"/doc/*
}

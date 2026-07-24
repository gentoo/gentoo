# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
CMAKE_IN_SOURCE_BUILD="yes"
LUA_COMPAT=( lua5-{1..3} luajit )

inherit desktop lua-single xdg cmake

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/CelestiaProject/Celestia.git"
	inherit git-r3
else
	if [[ ${PV} == *_p* ]] ; then
		COMMIT_ID="329e03ae8858e3c12386c603f0a034649cf17f8a"
		COMMIT_ID_DATA="d156a8b5ed3f03add56c706880cc879b99ba26f9"
		SRC_URI="
			https://github.com/${PN^}Project/${PN^}/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz
			https://github.com/${PN^}Project/${PN^}Content/archive/${COMMIT_ID_DATA}.tar.gz -> ${P}-data.tar.gz
		"
		S="${WORKDIR}/${PN^}-${COMMIT_ID}"
		KEYWORDS="~amd64 ~x86"
	else
		SRC_URI="https://github.com/${PN^}Project/${PN^}/archive/${PV/_/-}.tar.gz -> ${P}.tar.gz"
	fi
fi

DESCRIPTION="OpenGL 3D space simulator"
HOMEPAGE="https://celestiaproject.space/ https://github.com/CelestiaProject/Celestia"

LICENSE="GPL-2+"
SLOT="0"

# sdl backend needs imgui, which is not in the main tree yet.
# Default to qt6 support then
#IUSE="ffmpeg lto lua nls +qt6 sdl test"
IUSE="ffmpeg lto lua nls test"
RESTRICT="!test? ( test )"
#REQUIRED_USE="|| ( qt6 sdl )
REQUIRED_USE="
	lua? ( ${LUA_REQUIRED_USE} )
"

BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"
# qt6? ( dev-qt/qtbase:6[gui,opengl,widgets] )
# sdl? ( media-libs/libsdl2[X] media-libs/imgui )
DEPEND="
	dev-cpp/eigen:=
	>=dev-libs/boost-1.67:=
	>=dev-libs/libfmt-8.1.0:=
	media-libs/freetype
	media-libs/libepoxy
	media-libs/libjpeg-turbo:0=
	media-libs/libpng:0=
	virtual/zlib:=
	virtual/glu
	virtual/opengl
	ffmpeg? ( media-video/ffmpeg:0= )
	lua? ( ${LUA_DEPS} )
	dev-qt/qtbase:6[gui,opengl,widgets]
"
RDEPEND="${DEPEND}"

PATCHES=(
	# allow forcing CMake to look for a specific Lua version instead of the newest branch installed
	"${FILESDIR}"/${PN}-1.7.0-cmake_lua_version-r1.patch
)

src_prepare() {
	mv "${WORKDIR}"/CelestiaContent-${COMMIT_ID_DATA} content || die
	cmake_src_prepare
}

src_configure() {
	CMAKE_USE_DIR="${CMAKE_USE_DIR}/content" BUILD_DIR="${BUILD_DIR}/content" \
		cmake_src_configure

	# -DENABLE_QT6="$(usex qt6)"
	# -DENABLE_SDL="$(usex sdl)"
	local mycmakeargs=(
		-DCELCFG_EXTRAS_DIRS='"~/.celestia"'
		-DENABLE_CELX="$(usex lua)"
		-DENABLE_NLS="$(usex nls)"
		-DENABLE_FFMPEG="$(usex ffmpeg)"
		-DENABLE_LTO="$(usex lto)"
		-DENABLE_QT6=ON
		-DENABLE_WIN=OFF
		-DENABLE_SDL=OFF
		-DENABLE_TESTS="$(usex test)"
	)
	# Upstream always looks for LuaJIT first unless stopped, and we only need
	# the version specification when linking against PUC Lua
	if use lua && ! use lua_single_target_luajit; then
		mycmakeargs+=(
			-DCMAKE_DISABLE_FIND_PACKAGE_LuaJIT=ON
			-DLUA_VERSION=$(lua_get_version)
		)
	fi
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	CMAKE_USE_DIR="${CMAKE_USE_DIR}/content" BUILD_DIR="${BUILD_DIR}/content" cmake_src_compile
}

src_install() {
	cmake_src_install

	# Icons with more resolutions
	newicon ${PN}-logo.png ${PN}.png

	dodoc AUTHORS README TRANSLATORS *.txt

	CMAKE_USE_DIR="${CMAKE_USE_DIR}/content" BUILD_DIR="${BUILD_DIR}/content" cmake_src_install
}

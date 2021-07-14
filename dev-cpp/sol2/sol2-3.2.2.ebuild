# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1,3,4} luajit )
inherit cmake lua

DESCRIPTION="Header-only C++ <-> Lua API wrapper"
HOMEPAGE="https://github.com/ThePhD/sol2"
SRC_URI="https://github.com/ThePhD/sol2/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
REQUIRED_USE="test? ( ${LUA_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		${LUA_DEPS}
		dev-cpp/catch:0
	)
"
BDEPEND="
	test? (
		virtual/pkgconfig
	)
"

PATCHES=(
	"${FILESDIR}"/${P}-gcc11.patch
	"${FILESDIR}"/${P}-luajit-pkgconf.patch
	"${FILESDIR}"/${P}-catch-depend.patch
)

src_prepare() {
	# TODO: remove this sed on next bump
	sed -i -e 's/-Werror//' \
		tests/runtime_tests/CMakeLists.txt \
		tests/regression_tests/1011/CMakeLists.txt \
		tests/config_tests/function_pointers/CMakeLists.txt \
		examples/customization/CMakeLists.txt \
		examples/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	cmake_src_configure

	if use test; then
		sol2_configure_wrapper() {
			local mycmakeargs=(
				-DSOL2_BUILD_LUA=no
				-DSOL2_TESTS=yes
				-DSOL2_LUA_VERSION="${ELUA}"
				-DCATCH_INC_DIR="${ESYSROOT}/usr/include/catch2"
			)
			cmake_src_configure
		}
		lua_foreach_impl sol2_configure_wrapper
	fi
}

src_compile() {
	use test && lua_foreach_impl cmake_src_compile
}

src_test() {
	sol2_test_wrapper() {
		if [[ ${ELUA} == luajit ]]; then
			einfo "Skipping test due to https://github.com/ThePhD/sol2/issues/1221"
		else
			cmake_src_test
		fi
	}
	lua_foreach_impl sol2_test_wrapper
}

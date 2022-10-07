# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1,3,4} luajit )
inherit cmake lua

DESCRIPTION="Header-only C++ <-> Lua API wrapper"
HOMEPAGE="https://github.com/ThePhD/sol2"
SRC_URI="https://github.com/ThePhD/sol2/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

DEPEND="
	${LUA_DEPS}
	test? (
		>=dev-cpp/catch-3
	)
"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/sol2-3.3.0-werror.patch
	"${FILESDIR}"/sol2-3.2.2-luajit-pkgconf.patch
	"${FILESDIR}"/sol2-3.3.0-catch-depend.patch
	"${FILESDIR}"/sol2-3.3.0-cmake-dir.patch
	"${FILESDIR}"/sol2-3.3.0-dont-install-tests.patch
)

src_configure() {
	sol2_configure_wrapper() {
		local mycmakeargs=(
			-DSOL2_BUILD_LUA=no
			-DSOL2_TESTS=$(usex test)
			-DSOL2_LUA_VERSION="${ELUA}"
		)
		cmake_src_configure
	}
	lua_foreach_impl sol2_configure_wrapper
}

src_compile() {
	lua_foreach_impl cmake_src_compile
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

src_install() {
	lua_foreach_impl cmake_src_install
}

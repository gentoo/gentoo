# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11,12} )

inherit cmake-multilib python-single-r1

DESCRIPTION="A microbenchmark support library"
HOMEPAGE="https://github.com/google/benchmark/"
SRC_URI="https://github.com/google/benchmark/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1)"
KEYWORDS="amd64 ~arm arm64 ~hppa ~loong ~ppc ppc64 ~riscv x86"
IUSE="doc +exceptions libcxx libpfm lto test +tools"
RESTRICT="!test? ( test )"
REQUIRED_USE="tools? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	libcxx? ( llvm-runtimes/libcxx[${MULTILIB_USEDEP}] )
	libpfm? ( dev-libs/libpfm:= )
"

BDEPEND="
	>=dev-build/cmake-3.10
	doc? ( app-text/doxygen )
	test? ( dev-cpp/gtest[${MULTILIB_USEDEP}] )
"

RDEPEND="
	tools? (
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
			>=dev-python/scipy-1.10.0[${PYTHON_USEDEP}]
		')

		${PYTHON_DEPS}
	)
"

PATCHES=( "${FILESDIR}/${P}-fix-documentation-installation.patch" )

pkg_setup() {
	use tools && python-single-r1_pkg_setup
}

multilib_src_configure() {
	local mycmakeargs=(
		-DBENCHMARK_ENABLE_DOXYGEN="$(usex doc)"
		-DBENCHMARK_ENABLE_EXCEPTIONS="$(usex exceptions)"
		-DBENCHMARK_ENABLE_GTEST_TESTS="$(usex test)"
		-DBENCHMARK_ENABLE_LTO="$(usex lto)"
		-DBENCHMARK_ENABLE_LIBPFM="$(usex libpfm)"
		-DBENCHMARK_ENABLE_TESTING="$(usex test)"
		-DBENCHMARK_ENABLE_WERROR=OFF
		-DBENCHMARK_INSTALL_DOCS="$(usex doc)"
		-DBENCHMARK_USE_BUNDLED_GTEST=OFF
		-DBENCHMARK_USE_LIBCXX="$(usex libcxx)"
	)

	cmake_src_configure
}

multilib_src_install_all() {
	dodoc CONTRIBUTING.md
	dodoc CONTRIBUTORS

	if use tools; then
		python_domodule tools/gbench
		python_doscript tools/compare.py
		python_doscript tools/strip_asm.py
	fi
}

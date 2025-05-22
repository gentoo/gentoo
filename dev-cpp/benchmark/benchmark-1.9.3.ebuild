# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

inherit cmake-multilib flag-o-matic python-single-r1

DESCRIPTION="A microbenchmark support library"
HOMEPAGE="https://github.com/google/benchmark/"
SRC_URI="https://github.com/google/benchmark/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="doc debug libpfm test +tools"
RESTRICT="!test? ( test )"
REQUIRED_USE="tools? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="libpfm? ( dev-libs/libpfm:= )"

RDEPEND="
	${DEPEND}

	tools? (
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
			>=dev-python/scipy-1.10.0[${PYTHON_USEDEP}]
		')

		${PYTHON_DEPS}
	)
"

BDEPEND="
	doc? ( app-text/doxygen )
	test? ( dev-cpp/gtest[${MULTILIB_USEDEP}] )
"

PATCHES=( "${FILESDIR}/${PN}-1.9.0-fix-documentation-installation.patch" )

pkg_setup() {
	use tools && python-single-r1_pkg_setup
}

multilib_src_configure() {
	# bug #943629
	use debug || append-cppflags -DNDEBUG

	local mycmakeargs=(
		-DBENCHMARK_ENABLE_DOXYGEN="$(usex doc)"
		-DBENCHMARK_ENABLE_GTEST_TESTS="$(usex test)"

		# Users should control this via *FLAGS
		-DBENCHMARK_ENABLE_LTO=OFF

		-DBENCHMARK_ENABLE_LIBPFM="$(multilib_native_usex libpfm)"
		-DBENCHMARK_ENABLE_TESTING="$(usex test)"
		-DBENCHMARK_ENABLE_WERROR=OFF
		-DBENCHMARK_INSTALL_DOCS="$(usex doc)"
		-DBENCHMARK_USE_BUNDLED_GTEST=OFF

		# This is determined by profile
		-DBENCHMARK_USE_LIBCXX=OFF
	)

	cmake_src_configure
}

multilib_src_test() {
	CMAKE_SKIP_TESTS=(
		# CMake already warns on these being brittle w/ diff
		# compiler versions. Could do with investigation if bored
		# but not critical. See bug #941538.

		run_donotoptimize_assembly_test_CHECK
		run_state_assembly_test_CHECK
		run_clobber_memory_assembly_test_CHECK
	)

	cmake_src_test
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

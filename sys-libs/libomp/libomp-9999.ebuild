# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
# (needed due to CMAKE_BUILD_TYPE != Gentoo)
CMAKE_MIN_VERSION=3.7.0-r1
PYTHON_COMPAT=( python2_7 )

inherit cmake-multilib git-r3 linux-info python-any-r1

DESCRIPTION="OpenMP runtime library for LLVM/clang compiler"
HOMEPAGE="https://openmp.llvm.org"
SRC_URI=""
EGIT_REPO_URI="https://git.llvm.org/git/openmp.git
	https://github.com/llvm-mirror/openmp.git"

# Additional licenses:
# - MIT-licensed Intel code,
# - LLVM Software Grant from Intel.

LICENSE="|| ( UoI-NCSA MIT ) MIT LLVM-Grant"
SLOT="0"
KEYWORDS=""
IUSE="hwloc ompt test"
RESTRICT="!test? ( test )"

RDEPEND="hwloc? ( sys-apps/hwloc:0=[${MULTILIB_USEDEP}] )"
# tests:
# - dev-python/lit provides the test runner
# - sys-devel/llvm provide test utils (e.g. FileCheck)
# - sys-devel/clang provides the compiler to run tests
DEPEND="${RDEPEND}
	dev-lang/perl
	test? (
		$(python_gen_any_dep 'dev-python/lit[${PYTHON_USEDEP}]')
		sys-devel/llvm
		>=sys-devel/clang-6
	)"

# least intrusive of all
CMAKE_BUILD_TYPE=RelWithDebInfo

CONFIG_CHECK="~!SCHED_PDS"
ERROR_SCHED_PDS="PDS scheduler versions >= 0.98c < 0.98i (e.g. used in kernels
>= 4.13-pf11, no fixed release yet) do not implement sched_yield() call which
may result in horrible performance problems with libomp. If you are using one
of the specified kernel versions, you may want to disable the PDS scheduler."

python_check_deps() {
	has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_pretend() {
	linux-info_pkg_setup
}

pkg_setup() {
	linux-info_pkg_setup
	use test && python-any-r1_pkg_setup
}

multilib_src_configure() {
	local libdir="$(get_libdir)"
	local mycmakeargs=(
		-DOPENMP_LIBDIR_SUFFIX="${libdir#lib}"

		-DLIBOMP_USE_HWLOC=$(usex hwloc)
		-DLIBOMP_OMPT_SUPPORT=$(usex ompt)
		# do not install libgomp.so & libiomp5.so aliases
		-DLIBOMP_INSTALL_ALIASES=OFF
		# disable unnecessary hack copying stuff back to srcdir
		-DLIBOMP_COPY_EXPORTS=OFF
	)
	use test && mycmakeargs+=(
		-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
		-DLLVM_LIT_ARGS="-vv"

		-DOPENMP_TEST_C_COMPILER="$(type -P "${CHOST}-clang")"
		-DOPENMP_TEST_CXX_COMPILER="$(type -P "${CHOST}-clang++")"
	)
	cmake-utils_src_configure
}

multilib_src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1

	cmake-utils_src_make check-libomp
}

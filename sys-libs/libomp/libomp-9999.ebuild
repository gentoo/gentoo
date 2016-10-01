# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
PYTHON_COMPAT=( python2_7 )

inherit cmake-multilib git-r3 python-any-r1

DESCRIPTION="OpenMP runtime library for LLVM/clang compiler"
HOMEPAGE="http://openmp.llvm.org"
SRC_URI=""
EGIT_REPO_URI="http://llvm.org/git/openmp.git
	https://github.com/llvm-mirror/openmp.git"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS=""
IUSE="hwloc ompt test"

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
		>=sys-devel/clang-3.9.0
	)"

python_check_deps() {
	has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

multilib_src_configure() {
	local libdir="$(get_libdir)"
	local mycmakeargs=(
		-DLIBOMP_LIBDIR_SUFFIX="${libdir#lib}"
		-DLIBOMP_USE_HWLOC=$(usex hwloc)
		-DLIBOMP_OMPT_SUPPORT=$(usex ompt)
		# do not install libgomp.so & libiomp5.so aliases
		-DLIBOMP_INSTALL_ALIASES=OFF
		# disable unnecessary hack copying stuff back to srcdir
		-DLIBOMP_COPY_EXPORTS=OFF
		-DLIBOMP_TEST_COMPILER="${EPREFIX}/usr/bin/${CHOST}-clang"
	)
	cmake-utils_src_configure
}

multilib_src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1

	cmake-utils_src_make check-libomp
}

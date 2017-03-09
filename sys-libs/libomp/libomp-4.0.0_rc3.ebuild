# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
# (needed due to CMAKE_BUILD_TYPE != Gentoo)
CMAKE_MIN_VERSION=3.7.0-r1
PYTHON_COMPAT=( python2_7 )

inherit cmake-multilib python-any-r1

DESCRIPTION="OpenMP runtime library for LLVM/clang compiler"
HOMEPAGE="http://openmp.llvm.org"
SRC_URI="http://www.llvm.org/pre-releases/${PV/_//}/openmp-${PV/_/}.src.tar.xz"

# Additional licenses:
# - MIT-licensed Intel code,
# - LLVM Software Grant from Intel.

LICENSE="|| ( UoI-NCSA MIT ) MIT LLVM-Grant"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
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

S=${WORKDIR}/openmp-${PV/_/}.src

# least intrusive of all
CMAKE_BUILD_TYPE=RelWithDebInfo

python_check_deps() {
	has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	# fix atomic tests with gcc
	eapply "${FILESDIR}"/4.0.0/0001-test-Try-to-link-latomic-to-provide-atomics-when-ava.patch

	eapply_user
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
		-DLIBOMP_TEST_COMPILER="$(type -P "${CHOST}-clang")"
	)
	cmake-utils_src_configure
}

multilib_src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1

	cmake-utils_src_make check-libomp
}

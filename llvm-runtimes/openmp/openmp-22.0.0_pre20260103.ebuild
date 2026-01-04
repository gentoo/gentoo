# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit flag-o-matic cmake-multilib linux-info llvm.org python-single-r1

DESCRIPTION="OpenMP runtime library for LLVM/clang compiler"
HOMEPAGE="https://openmp.llvm.org"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )"
SLOT="0/${LLVM_SOABI}"
IUSE="+debug gdb-plugin hwloc ompt test"
REQUIRED_USE="
	gdb-plugin? ( ${PYTHON_REQUIRED_USE} )
"
RESTRICT="!test? ( test )"

RDEPEND="
	gdb-plugin? ( ${PYTHON_DEPS} )
	hwloc? ( >=sys-apps/hwloc-2.5:0=[${MULTILIB_USEDEP}] )
"
# tests:
# - dev-python/lit provides the test runner
# - llvm-core/llvm provide test utils (e.g. FileCheck)
# - llvm-core/clang provides the compiler to run tests
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-lang/perl
	test? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/lit[${PYTHON_USEDEP}]
		')
		llvm-core/clang
	)
"

LLVM_COMPONENTS=( runtimes openmp cmake llvm/{cmake,include,utils/llvm-lit} )
llvm.org_set_globals

pkg_setup() {
	if use gdb-plugin || use test; then
		python-single-r1_pkg_setup
	fi
}

multilib_src_configure() {
	# LTO causes issues in other packages building, #870127
	filter-lto

	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"

	local libdir="$(get_libdir)"
	local mycmakeargs=(
		-DLLVM_ENABLE_RUNTIMES=openmp
		-DOPENMP_STANDALONE_BUILD=ON
		-DOPENMP_LIBDIR_SUFFIX="${libdir#lib}"

		-DLIBOMP_USE_HWLOC=$(usex hwloc)
		-DLIBOMP_OMPD_GDB_SUPPORT=$(multilib_native_usex gdb-plugin)
		-DLIBOMP_OMPT_SUPPORT=$(usex ompt)

		# do not install libgomp.so & libiomp5.so aliases
		-DLIBOMP_INSTALL_ALIASES=OFF
		# disable unnecessary hack copying stuff back to srcdir
		-DLIBOMP_COPY_EXPORTS=OFF
	)

	use test && mycmakeargs+=(
		# this project does not use standard LLVM cmake macros
		-DOPENMP_LLVM_LIT_EXECUTABLE="${EPREFIX}/usr/bin/lit"
		-DOPENMP_LIT_ARGS="$(get_lit_flags)"

		-DOPENMP_TEST_C_COMPILER="$(type -P "${CHOST}-clang")"
		-DOPENMP_TEST_CXX_COMPILER="$(type -P "${CHOST}-clang++")"
		# disable Fortran tests for now
		# (TODO: enable where we have flang keyworded)
		-DOPENMP_TEST_Fortran_COMPILER=
	)
	cmake_src_configure
}

multilib_src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1

	cmake_build check-openmp
}

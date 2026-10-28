# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
inherit cmake flag-o-matic llvm.org python-any-r1 toolchain-funcs

DESCRIPTION="LLVM's Fortran frontend"
HOMEPAGE="https://flang.llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions"
SLOT="${LLVM_MAJOR}/${LLVM_SOABI}"
IUSE="+clang +debug test"
RESTRICT="!test? ( test )"

DEPEND="
	~llvm-core/clang-${PV}[debug=]
	~llvm-core/llvm-${PV}[debug=]
	~llvm-core/mlir-${PV}[debug=]
"
RDEPEND="
	${DEPEND}
"
PDEPEND="
	>=llvm-runtimes/flang-rt-${PV}:${LLVM_MAJOR}
"
BDEPEND="
	clang? ( llvm-core/clang )
	test? (
		$(python_gen_any_dep 'dev-python/lit[${PYTHON_USEDEP}]')
	)
"

LLVM_COMPONENTS=( flang cmake )
LLVM_TEST_COMPONENTS=(
	clang/test/Driver mlir/test/lib
	# for building flang-rt
	runtimes flang-rt libc/shared llvm/{cmake,utils}
	# openmp
	openmp third-party/unittest
)
LLVM_USE_TARGETS=llvm+eq
llvm.org_set_globals

python_check_deps() {
	python_has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_pretend() {
	if ! use clang && tc-is-gcc; then
		ewarn "Building using GCC requires lots of memory (up to 10 GiB per process)."
		ewarn "Consider enabling USE=clang."
		ewarn "See https://gcc.gnu.org/PR119705"
	fi
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	# create extra parent dir for relative CLANG_RESOURCE_DIR access
	mkdir -p x/y || die
	BUILD_DIR=${WORKDIR}/x/y/build

	llvm.org_src_prepare
}

src_configure() {
	if use clang; then
		# Only do this conditionally to allow overriding with
		# e.g. CC=clang-13 in case of breakage
		if ! tc-is-clang ; then
			local -x CC=${CHOST}-clang
			local -x CXX=${CHOST}-clang++
		fi

		strip-unsupported-flags
	fi

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}"

		-DLLVM_ROOT="${ESYSROOT}/usr/lib/llvm/${LLVM_MAJOR}"
		-DCLANG_RESOURCE_DIR="../../../clang/${LLVM_MAJOR}"

		-DBUILD_SHARED_LIBS=OFF
		-DMLIR_LINK_MLIR_DYLIB=ON
		# flang does not feature a dylib, so do not install libraries
		# or headers
		-DLLVM_INSTALL_TOOLCHAIN_ONLY=ON
		# installed by llvm-runtimes/flang-rt
		-DFLANG_INCLUDE_RUNTIME=OFF

		# TODO: always enable to obtain reproducible tools
		-DFLANG_INCLUDE_TESTS=$(usex test)

		-DLLVM_TARGETS_TO_BUILD="${LLVM_TARGETS// /;}"
	)
	use test && mycmakeargs+=(
		-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
		-DLLVM_LIT_ARGS="$(get_lit_flags)"
	)

	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"
	cmake_src_configure
}

build_runtimes() {
	local -x FC=${BUILD_DIR}/bin/flang
	local -x F77=${FC}
	local CMAKE_USE_DIR=${WORKDIR}/runtimes
	local BUILD_DIR=${WORKDIR}/runtimes_build
	strip-unsupported-flags

	local mycmakeargs=(
		# cmake.eclass does not set if it we don't inherit fortran-2
		# and upstream code relies on it being set before Fortran logic
		# kicks in and reds envvars
		-DCMAKE_Fortran_COMPILER="${FC}"
		# we may not have a runtime yet
		-DCMAKE_Fortran_COMPILER_WORKS=TRUE
		# tests rddequire modules now
		-DRUNTIMES_FORTRAN_MODULES=ON

		-DLLVM_ENABLE_RUNTIMES="flang-rt;openmp"
		# this package forces NO_DEFAULT_PATHS
		-DLLVM_BINARY_DIR="${ESYSROOT}/usr/lib/llvm/${LLVM_MAJOR}"
		-DLLVM_DEFAULT_TARGET_TRIPLE="${CHOST}"

		# install inside the test tree
		-DRUNTIMES_INSTALL_RESOURCE_PATH="${WORKDIR}/lib/clang/${LLVM_MAJOR}"
		# work hard not to install anything else
		-DLLVM_INSTALL_TOOLCHAIN_ONLY=ON
		-DOPENMP_INSTALL_LIBDIR="${T}/discard"

		-DFLANG_RT_INCLUDE_TESTS=OFF
		-DLIBOMP_FORTRAN_MODULES_ONLY=ON
		-DLIBOMP_USE_HWLOC=OFF
		-DLIBOMP_OMPD_GDB_SUPPORT=OFF
		-DLIBOMP_OMPT_SUPPORT=OFF
	)

	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"
	cmake_src_configure
	cmake_build install
}

src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1

	build_runtimes

	cmake_build check-flang
}

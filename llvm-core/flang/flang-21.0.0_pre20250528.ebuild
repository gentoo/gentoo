# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit cmake llvm.org python-any-r1

DESCRIPTION="LLVM's Fortran frontend"
HOMEPAGE="https://flang.llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions"
SLOT="${LLVM_MAJOR}/${LLVM_SOABI}"
IUSE="+debug test"
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
	test? (
		$(python_gen_any_dep 'dev-python/lit[${PYTHON_USEDEP}]')
	)
"

LLVM_COMPONENTS=( flang cmake )
LLVM_TEST_COMPONENTS=( clang/test/Driver mlir/test/lib )
llvm.org_set_globals

python_check_deps() {
	python_has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
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
	)
	use test && mycmakeargs+=(
		-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
		-DLLVM_LIT_ARGS="$(get_lit_flags)"
	)

	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"
	cmake_src_configure
}

src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	cmake_build check-flang
}

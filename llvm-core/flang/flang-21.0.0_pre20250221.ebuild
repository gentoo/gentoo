# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake llvm.org

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
BDEPEND="
	test? (
		dev-python/lit
	)
"

LLVM_COMPONENTS=( flang flang-rt cmake )
LLVM_TEST_COMPONENTS=( clang/test/Driver mlir/test/lib )
llvm.org_set_globals

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

src_install() {
	cmake_src_install

	# move the runtime into 'lib' (sigh), until upstream resolves
	# libdir support: https://github.com/llvm/llvm-project/issues/127538
	mv "${ED}/usr/lib/llvm/${LLVM_MAJOR}"/{$(get_libdir),lib} || die
}

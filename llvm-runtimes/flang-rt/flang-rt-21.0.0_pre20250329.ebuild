# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic llvm.org

DESCRIPTION="LLVM's Fortran runtime"
HOMEPAGE="https://flang.llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions"
SLOT="${LLVM_MAJOR}"
IUSE="+debug test"
RESTRICT="!test? ( test )"

RDEPEND="
	!<llvm-core/flang-21.0.0_pre20250221-r1
"
BDEPEND="
	llvm-core/llvm:${LLVM_MAJOR}
	llvm-core/flang
	test? (
		dev-python/lit
	)
"

LLVM_COMPONENTS=(
	runtimes flang-rt cmake flang llvm/{cmake,utils/llvm-lit}
)
llvm.org_set_globals

src_configure() {
	# the code is not portable
	local -x FC=flang F77=flang
	strip-unsupported-flags

	local mycmakeargs=(
		# we may not have a runtime yet
		-DCMAKE_Fortran_COMPILER_WORKS=TRUE

		-DLLVM_ENABLE_RUNTIMES="flang-rt"
		# this package forces NO_DEFAULT_PATHS
		-DLLVM_BINARY_DIR="${ESYSROOT}/usr/lib/llvm/${LLVM_MAJOR}"

		-DFLANG_RT_INCLUDE_TESTS=$(usex test)
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
	cmake_build check-flang-rt
}

src_install() {
	cmake_src_install

	# in standalone build, the library is installed to (incorrect) resource dir
	# but the driver only looks for it in lib (sigh)
	# https://github.com/llvm/llvm-project/issues/127538
	mkdir -p "${ED}/usr/lib/llvm/${LLVM_MAJOR}" || die
	mv "${ED}/usr/$(get_libdir)/clang/${LLVM_MAJOR}/lib"/* \
		"${ED}/usr/lib/llvm/${LLVM_MAJOR}/lib" || die
}

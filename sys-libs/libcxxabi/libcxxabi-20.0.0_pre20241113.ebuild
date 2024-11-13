# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit cmake-multilib flag-o-matic llvm.org llvm-utils python-any-r1
inherit toolchain-funcs

DESCRIPTION="Low level support for a standard C++ library"
HOMEPAGE="https://libcxxabi.llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )"
SLOT="0"
IUSE="+clang +static-libs test"
REQUIRED_USE="test? ( clang )"
RESTRICT="!test? ( test )"

# in 15.x, cxxabi.h is moving from libcxx to libcxxabi
RDEPEND+="
	!<sys-libs/libcxx-15
"
DEPEND="
	${RDEPEND}
	sys-devel/llvm:${LLVM_MAJOR}
"
BDEPEND="
	clang? (
		sys-devel/clang:${LLVM_MAJOR}
	)
	!test? (
		${PYTHON_DEPS}
	)
	test? (
		$(python_gen_any_dep 'dev-python/lit[${PYTHON_USEDEP}]')
	)
"

LLVM_COMPONENTS=( runtimes libcxx{abi,} llvm/cmake cmake )
LLVM_TEST_COMPONENTS=( libc llvm/utils/llvm-lit )
llvm.org_set_globals

python_check_deps() {
	use test || return 0
	python_has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

multilib_src_configure() {
	llvm_prepend_path "${LLVM_MAJOR}"

	if use clang; then
		local -x CC=${CHOST}-clang
		local -x CXX=${CHOST}-clang++
		strip-unsupported-flags
	fi

	# link to compiler-rt
	local use_compiler_rt=OFF
	[[ $(tc-get-c-rtlib) == compiler-rt ]] && use_compiler_rt=ON

	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DCMAKE_CXX_COMPILER_TARGET="${CHOST}"
		-DPython3_EXECUTABLE="${PYTHON}"
		-DLLVM_ENABLE_RUNTIMES="libcxxabi;libcxx"
		-DLLVM_INCLUDE_TESTS=OFF
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBCXXABI_ENABLE_SHARED=ON
		-DLIBCXXABI_ENABLE_STATIC=$(usex static-libs)
		-DLIBCXXABI_INCLUDE_TESTS=$(usex test)
		-DLIBCXXABI_USE_COMPILER_RT=${use_compiler_rt}

		# upstream is omitting standard search path for this
		# probably because gcc & clang are bundling their own unwind.h
		-DLIBCXXABI_LIBUNWIND_INCLUDES="${EPREFIX}"/usr/include
		# this is broken with standalone builds, and also meaningless
		-DLIBCXXABI_USE_LLVM_UNWINDER=OFF

		-DLIBCXX_ENABLE_SHARED=ON
		-DLIBCXX_ENABLE_STATIC=OFF
		-DLIBCXX_CXX_ABI=libcxxabi
		-DLIBCXX_ENABLE_ABI_LINKER_SCRIPT=OFF
		-DLIBCXX_HAS_MUSL_LIBC=$(usex elibc_musl)
		-DLIBCXX_HAS_GCC_S_LIB=OFF
		-DLIBCXX_INCLUDE_BENCHMARKS=OFF
		-DLIBCXX_INCLUDE_TESTS=OFF
	)
	if use test; then
		mycmakeargs+=(
			-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
			-DLLVM_LIT_ARGS="$(get_lit_flags)"
			-DPython3_EXECUTABLE="${PYTHON}"
		)
	fi
	cmake_src_configure
}

multilib_src_compile() {
	cmake_build cxxabi
}

multilib_src_test() {
	local -x LIT_PRESERVES_TMP=1
	cmake_build check-cxxabi
}

multilib_src_install() {
	DESTDIR="${D}" cmake_build install-cxxabi
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )
inherit cmake-multilib flag-o-matic llvm llvm.org python-any-r1 toolchain-funcs

DESCRIPTION="C++ runtime stack unwinder from LLVM"
HOMEPAGE="https://llvm.org/docs/ExceptionHandling.html"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 ~riscv sparc x86 ~x64-macos"
IUSE="debug static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	!sys-libs/libunwind
"
# llvm-6 for new lit options
DEPEND="
	>=sys-devel/llvm-6
"
BDEPEND="
	!test? (
		${PYTHON_DEPS}
	)
	test? (
		>=sys-devel/clang-3.9.0
		$(python_gen_any_dep 'dev-python/lit[${PYTHON_USEDEP}]')
	)
"

LLVM_COMPONENTS=( runtimes libunwind libcxx llvm/cmake cmake )
LLVM_TEST_COMPONENTS=( libcxxabi llvm/utils/llvm-lit )
llvm.org_set_globals

python_check_deps() {
	use test || return 0
	python_has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

multilib_src_configure() {
	local libdir=$(get_libdir)

	# https://github.com/llvm/llvm-project/issues/56825
	# also separately bug #863917
	filter-lto

	# link to compiler-rt
	# https://github.com/gentoo/gentoo/pull/21516
	local use_compiler_rt=OFF
	[[ $(tc-get-c-rtlib) == compiler-rt ]] && use_compiler_rt=ON

	local mycmakeargs=(
		-DPython3_EXECUTABLE="${PYTHON}"
		-DLLVM_ENABLE_RUNTIMES="libunwind"
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
		-DLLVM_INCLUDE_TESTS=OFF
		-DLIBUNWIND_ENABLE_ASSERTIONS=$(usex debug)
		-DLIBUNWIND_ENABLE_STATIC=$(usex static-libs)
		-DLIBUNWIND_INCLUDE_TESTS=$(usex test)
		-DLIBUNWIND_INSTALL_HEADERS=ON
		-DLIBUNWIND_TARGET_TRIPLE="${CHOST}"

		# support non-native unwinding; given it's small enough,
		# enable it unconditionally
		-DLIBUNWIND_ENABLE_CROSS_UNWINDING=ON

		# avoid dependency on libgcc_s if compiler-rt is used
		-DLIBUNWIND_USE_COMPILER_RT=${use_compiler_rt}
	)
	if use test; then
		mycmakeargs+=(
			-DLLVM_ENABLE_RUNTIMES="libunwind;libcxxabi;libcxx"
			-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
			-DLLVM_LIT_ARGS="$(get_lit_flags)"
			-DLIBUNWIND_LIBCXX_PATH="${WORKDIR}/libcxx"

			-DLIBCXXABI_LIBDIR_SUFFIX=
			-DLIBCXXABI_ENABLE_SHARED=OFF
			-DLIBCXXABI_ENABLE_STATIC=ON
			-DLIBCXXABI_USE_LLVM_UNWINDER=ON
			-DLIBCXXABI_INCLUDE_TESTS=OFF

			-DLIBCXX_LIBDIR_SUFFIX=
			-DLIBCXX_ENABLE_SHARED=OFF
			-DLIBCXX_ENABLE_STATIC=ON
			-DLIBCXX_ENABLE_EXPERIMENTAL_LIBRARY=OFF
			-DLIBCXX_CXX_ABI=libcxxabi
			-DLIBCXX_ENABLE_ABI_LINKER_SCRIPT=OFF
			-DLIBCXX_HAS_MUSL_LIBC=$(usex elibc_musl)
			-DLIBCXX_HAS_GCC_S_LIB=OFF
			-DLIBCXX_INCLUDE_TESTS=OFF
			-DLIBCXX_INCLUDE_BENCHMARKS=OFF
		)
	fi

	cmake_src_configure

	if use test; then
		local clang_path=$(type -P "${CHOST:+${CHOST}-}clang" 2>/dev/null)
		[[ -n ${clang_path} ]] || die "Unable to find ${CHOST}-clang for tests"

		# meh, we need to override the compiler explicitly
		sed -e "/%{cxx}/s@, '.*'@, '${clang_path}'@" \
			-i "${BUILD_DIR}"/libunwind/test/lit.site.cfg || die
	fi
}

multilib_src_test() {
	local -x LIT_PRESERVES_TMP=1
	cmake_build check-unwind
}

multilib_src_install() {
	DESTDIR=${D} cmake_build install-unwind
}

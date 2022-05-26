# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
PYTHON_COMPAT=( python3_{8..10} )
inherit cmake-multilib llvm llvm.org python-any-r1 toolchain-funcs

DESCRIPTION="Low level support for a standard C++ library"
HOMEPAGE="https://libcxxabi.llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86 ~x64-macos"
IUSE="+libunwind static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	libunwind? (
		|| (
			>=sys-libs/libunwind-1.0.1-r1[static-libs?,${MULTILIB_USEDEP}]
			>=sys-libs/llvm-libunwind-3.9.0-r1[static-libs?,${MULTILIB_USEDEP}]
		)
	)"
# llvm-6 for new lit options
DEPEND="${RDEPEND}
	>=sys-devel/llvm-6"
BDEPEND="
	${PYTHON_DEPS}
	test? (
		>=sys-devel/clang-3.9.0
		$(python_gen_any_dep 'dev-python/lit[${PYTHON_USEDEP}]')
	)"

LLVM_COMPONENTS=( runtimes libcxx{abi,} llvm/cmake cmake )
LLVM_TEST_COMPONENTS=( llvm/utils/llvm-lit )
llvm.org_set_globals

python_check_deps() {
	use test || return 0
	has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	# darwin prefix builds do not have llvm installed yet, so rely on bootstrap-prefix
	# to set the appropriate path vars to LLVM instead of using llvm_pkg_setup.
	if [[ ${CHOST} != *-darwin* ]] || has_version dev-lang/llvm; then
		llvm_pkg_setup
	fi
	python-any-r1_pkg_setup
}

multilib_src_configure() {
	# link against compiler-rt instead of libgcc if we are using clang with libunwind
	local want_compiler_rt=OFF
	if use libunwind && tc-is-clang; then
		local compiler_rt=$($(tc-getCC) ${CFLAGS} ${CPPFLAGS} \
			${LDFLAGS} -print-libgcc-file-name)
		if [[ ${compiler_rt} == *libclang_rt* ]]; then
			want_compiler_rt=ON
		fi
	fi

	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DPython3_EXECUTABLE="${PYTHON}"
		-DLLVM_ENABLE_RUNTIMES="libcxxabi;libcxx"
		-DLLVM_INCLUDE_TESTS=OFF
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBCXXABI_ENABLE_SHARED=ON
		-DLIBCXXABI_ENABLE_STATIC=$(usex static-libs)
		-DLIBCXXABI_INCLUDE_TESTS=$(usex test)
		-DLIBCXXABI_USE_LLVM_UNWINDER=$(usex libunwind)
		-DLIBCXXABI_USE_COMPILER_RT=${want_compiler_rt}

		# upstream is omitting standard search path for this
		# probably because gcc & clang are bundling their own unwind.h
		-DLIBCXXABI_LIBUNWIND_INCLUDES="${EPREFIX}"/usr/include
		-DLIBCXXABI_TARGET_TRIPLE="${CHOST}"

		-DLIBCXX_LIBDIR_SUFFIX=
		-DLIBCXX_ENABLE_SHARED=ON
		-DLIBCXX_ENABLE_STATIC=OFF
		-DLIBCXX_ENABLE_EXPERIMENTAL_LIBRARY=OFF
		-DLIBCXX_CXX_ABI=libcxxabi
		-DLIBCXX_CXX_ABI_INCLUDE_PATHS="${WORKDIR}"/libcxxabi/include
		-DLIBCXX_ENABLE_ABI_LINKER_SCRIPT=OFF
		-DLIBCXX_HAS_MUSL_LIBC=$(usex elibc_musl)
		-DLIBCXX_HAS_GCC_S_LIB=OFF
		-DLIBCXX_INCLUDE_BENCHMARKS=OFF
		-DLIBCXX_INCLUDE_TESTS=OFF
		-DLIBCXX_TARGET_TRIPLE="${CHOST}"
	)
	if use test; then
		local clang_path=$(type -P "${CHOST:+${CHOST}-}clang" 2>/dev/null)
		[[ -n ${clang_path} ]] || die "Unable to find ${CHOST}-clang for tests"

		mycmakeargs+=(
			-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
			-DLLVM_LIT_ARGS="$(get_lit_flags);--param=cxx_under_test=${clang_path}"
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

multilib_src_install_all() {
	insinto /usr/include/libcxxabi
	doins -r "${WORKDIR}"/libcxxabi/include/.
}

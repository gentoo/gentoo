# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
PYTHON_COMPAT=( python3_{8..10} )
inherit cmake-multilib llvm llvm.org python-any-r1 toolchain-funcs

DESCRIPTION="C++ runtime stack unwinder from LLVM"
HOMEPAGE="https://github.com/llvm-mirror/libunwind"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 ~riscv ~x86 ~x64-macos"
IUSE="debug static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="!sys-libs/libunwind"
# llvm-6 for new lit options
DEPEND="
	>=sys-devel/llvm-6"
BDEPEND="
	test? ( >=sys-devel/clang-3.9.0
		$(python_gen_any_dep 'dev-python/lit[${PYTHON_USEDEP}]')
	)"

LLVM_COMPONENTS=( libunwind libcxx llvm/cmake )
LLVM_TEST_COMPONENTS=( libcxxabi )
LLVM_PATCHSET=${PV/_/-}
llvm.org_set_globals

python_check_deps() {
	has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

multilib_src_configure() {
	local use_compiler_rt=OFF
	local libdir=$(get_libdir)

	# link to compiler-rt
	# https://github.com/gentoo/gentoo/pull/21516
	if tc-is-clang; then
		local compiler_rt=$($(tc-getCC) ${CFLAGS} ${CPPFLAGS} \
		   ${LD_FLAGS} -print-libgcc-file-name)
		if [[ ${compiler_rt} == *libclang_rt* ]]; then
			use_compiler_rt=ON
		fi
	fi

	local mycmakeargs=(
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBUNWIND_ENABLE_ASSERTIONS=$(usex debug)
		-DLIBUNWIND_ENABLE_STATIC=$(usex static-libs)
		-DLIBUNWIND_TARGET_TRIPLE="${CHOST}"
		-DLLVM_INCLUDE_TESTS=$(usex test)

		# support non-native unwinding; given it's small enough,
		# enable it unconditionally
		-DLIBUNWIND_ENABLE_CROSS_UNWINDING=ON

		# avoid dependency on libgcc_s if compiler-rt is used
		-DLIBUNWIND_USE_COMPILER_RT=${use_compiler_rt}
	)
	if use test; then
		local clang_path=$(type -P "${CHOST:+${CHOST}-}clang" 2>/dev/null)
		[[ -n ${clang_path} ]] || die "Unable to find ${CHOST}-clang for tests"

		mycmakeargs+=(
			-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
			-DLLVM_LIT_ARGS="$(get_lit_flags);--param=cxx_under_test=${clang_path}"
			-DLIBUNWIND_LIBCXX_PATH="${WORKDIR}/libcxx"
		)
	fi

	cmake_src_configure
}

wrap_libcxxabi() {
	local mycmakeargs=(
		-DLIBCXXABI_LIBDIR_SUFFIX=
		-DLIBCXXABI_ENABLE_SHARED=OFF
		-DLIBCXXABI_ENABLE_STATIC=ON
		-DLIBCXXABI_USE_LLVM_UNWINDER=ON
		-DLIBCXXABI_INCLUDE_TESTS=OFF

		-DLIBCXXABI_LIBCXX_INCLUDES="${BUILD_DIR}"/libcxx/include/c++/v1
		-DLIBCXXABI_LIBUNWIND_INCLUDES="${S}"/include
	)

	local -x LDFLAGS="${LDFLAGS} -L${BUILD_DIR}/$(get_libdir)"
	local CMAKE_USE_DIR=${WORKDIR}/libcxxabi
	local BUILD_DIR=${BUILD_DIR}/libcxxabi

	"${@}"
}

wrap_libcxx() {
	local mycmakeargs=(
		-DLIBCXX_LIBDIR_SUFFIX=
		-DLIBCXX_ENABLE_SHARED=OFF
		-DLIBCXX_ENABLE_STATIC=ON
		-DLIBCXX_ENABLE_EXPERIMENTAL_LIBRARY=OFF
		-DLIBCXXABI_USE_LLVM_UNWINDER=ON
		-DLIBCXX_CXX_ABI=libcxxabi
		-DLIBCXX_CXX_ABI_INCLUDE_PATHS="${WORKDIR}"/libcxxabi/include
		-DLIBCXX_ENABLE_ABI_LINKER_SCRIPT=OFF
		-DLIBCXX_HAS_MUSL_LIBC=$(usex elibc_musl)
		-DLIBCXX_HAS_GCC_S_LIB=OFF
		-DLIBCXX_INCLUDE_TESTS=OFF
	)

	local -x LDFLAGS="${LDFLAGS} -L${BUILD_DIR}/libcxxabi/lib -L${BUILD_DIR}/$(get_libdir)"
	local CMAKE_USE_DIR=${WORKDIR}/libcxx
	local BUILD_DIR=${BUILD_DIR}/libcxx

	"${@}"
}

multilib_src_test() {
	# build local copies of libc++ & libc++abi for testing to avoid
	# circular deps
	wrap_libcxx cmake_src_configure
	wrap_libcxx cmake_build generate-cxx-headers
	wrap_libcxxabi cmake_src_configure
	wrap_libcxxabi cmake_src_compile
	wrap_libcxx cmake_src_compile
	mv "${BUILD_DIR}"/libcxx*/lib/libc++* "${BUILD_DIR}/$(get_libdir)/" || die

	local -x LIT_PRESERVES_TMP=1
	cmake_build check-unwind
}

multilib_src_install() {
	cmake_src_install

	# install headers like sys-libs/libunwind
	doheader "${S}"/include/*.h
}

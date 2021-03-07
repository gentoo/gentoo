# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
PYTHON_COMPAT=( python3_{7..9} )
inherit cmake-multilib llvm llvm.org python-any-r1

DESCRIPTION="C++ runtime stack unwinder from LLVM"
HOMEPAGE="https://github.com/llvm-mirror/libunwind"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~x64-macos"
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

LLVM_COMPONENTS=( libunwind )
LLVM_TEST_COMPONENTS=( libcxx{,abi} llvm/cmake )
llvm.org_set_globals

python_check_deps() {
	has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

multilib_src_configure() {
	local libdir=$(get_libdir)

	local mycmakeargs=(
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBUNWIND_ENABLE_ASSERTIONS=$(usex debug)
		-DLIBUNWIND_ENABLE_STATIC=$(usex static-libs)
		-DLLVM_INCLUDE_TESTS=$(usex test)

		# support non-native unwinding; given it's small enough,
		# enable it unconditionally
		-DLIBUNWIND_ENABLE_CROSS_UNWINDING=ON
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

build_libcxxabi() {
	local -x LDFLAGS="${LDFLAGS} -L${BUILD_DIR}/$(get_libdir)"
	local CMAKE_USE_DIR=${WORKDIR}/libcxxabi
	local BUILD_DIR=${BUILD_DIR}/libcxxabi
	local mycmakeargs=(
		-DLIBCXXABI_LIBDIR_SUFFIX=
		-DLIBCXXABI_ENABLE_SHARED=OFF
		-DLIBCXXABI_ENABLE_STATIC=ONF
		-DLIBCXXABI_USE_LLVM_UNWINDER=ON
		-DLIBCXXABI_INCLUDE_TESTS=OFF

		-DLIBCXXABI_LIBCXX_INCLUDES="${WORKDIR}"/libcxx/include
		-DLIBCXXABI_LIBUNWIND_INCLUDES="${S}"/include
	)

	cmake_src_configure
	cmake_src_compile
}

build_libcxx() {
	local -x LDFLAGS="${LDFLAGS} -L${BUILD_DIR}/libcxxabi/lib -L${BUILD_DIR}/$(get_libdir)"
	local CMAKE_USE_DIR=${WORKDIR}/libcxx
	local BUILD_DIR=${BUILD_DIR}/libcxx
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

	cmake_src_configure
	cmake_src_compile
}

multilib_src_test() {
	# build local copies of libc++ & libc++abi for testing to avoid
	# circular deps
	build_libcxxabi
	build_libcxx
	mv "${BUILD_DIR}"/libcxx*/lib/libc++* "${BUILD_DIR}/$(get_libdir)/" || die

	local -x LIT_PRESERVES_TMP=1
	cmake_build check-unwind
}

multilib_src_install() {
	cmake_src_install

	# install headers like sys-libs/libunwind
	doheader "${S}"/include/*.h
}

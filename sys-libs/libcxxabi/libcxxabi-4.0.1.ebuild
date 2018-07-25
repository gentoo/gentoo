# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
# (needed due to CMAKE_BUILD_TYPE != Gentoo)
CMAKE_MIN_VERSION=3.7.0-r1
PYTHON_COMPAT=( python2_7 )

inherit cmake-multilib llvm python-any-r1

DESCRIPTION="Low level support for a standard C++ library"
HOMEPAGE="https://libcxxabi.llvm.org/"
SRC_URI="https://releases.llvm.org/${PV/_//}/${P/_/}.src.tar.xz
	https://releases.llvm.org/${PV/_//}/libcxx-${PV/_/}.src.tar.xz"

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="+libunwind +static-libs test elibc_musl"

RDEPEND="
	libunwind? (
		|| (
			>=sys-libs/libunwind-1.0.1-r1[static-libs?,${MULTILIB_USEDEP}]
			>=sys-libs/llvm-libunwind-3.9.0-r1[static-libs?,${MULTILIB_USEDEP}]
		)
	)"
# LLVM 4 required for llvm-config --cmakedir
DEPEND="${RDEPEND}
	>=sys-devel/llvm-4
	test? ( >=sys-devel/clang-3.9.0
		$(python_gen_any_dep 'dev-python/lit[${PYTHON_USEDEP}]') )"

S=${WORKDIR}/${P/_/}.src

# least intrusive of all
CMAKE_BUILD_TYPE=RelWithDebInfo

python_check_deps() {
	has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	llvm_pkg_setup
	use test && python-any-r1_pkg_setup
}

src_unpack() {
	default

	mv libcxx-* libcxx || die
}

multilib_src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLIBCXXABI_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBCXXABI_ENABLE_SHARED=ON
		-DLIBCXXABI_ENABLE_STATIC=$(usex static-libs)
		-DLIBCXXABI_USE_LLVM_UNWINDER=$(usex libunwind)
		-DLIBCXXABI_INCLUDE_TESTS=$(usex test)

		-DLIBCXXABI_LIBCXX_INCLUDES="${WORKDIR}"/libcxx/include
		# upstream is omitting standard search path for this
		# probably because gcc & clang are bundling their own unwind.h
		-DLIBCXXABI_LIBUNWIND_INCLUDES="${EPREFIX}"/usr/include
		# this only needs to exist, it does not have to make sense
		# FIXME: remove this once https://reviews.llvm.org/D25314 is merged
		-DLIBCXXABI_LIBUNWIND_SOURCES="${T}"
	)
	if use test; then
		if has_version '>=sys-devel/llvm-6'; then
			mycmakeargs+=(
				-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
			)
		else
			mycmakeargs+=(
				-DLIT_COMMAND="${EPREFIX}"/usr/bin/lit
			)
		fi
	fi
	cmake-utils_src_configure
}

build_libcxx() {
	local -x LDFLAGS="${LDFLAGS} -L${BUILD_DIR}/$(get_libdir)"
	local CMAKE_USE_DIR=${WORKDIR}/libcxx
	local BUILD_DIR=${BUILD_DIR}/libcxx
	local mycmakeargs=(
		-DLIBCXX_LIBDIR_SUFFIX=
		-DLIBCXX_ENABLE_SHARED=ON
		-DLIBCXX_ENABLE_STATIC=OFF
		-DLIBCXX_ENABLE_EXPERIMENTAL_LIBRARY=OFF
		-DLIBCXX_CXX_ABI=libcxxabi
		-DLIBCXX_CXX_ABI_INCLUDE_PATHS="${S}"/include
		-DLIBCXX_ENABLE_ABI_LINKER_SCRIPT=OFF
		-DLIBCXX_HAS_MUSL_LIBC=$(usex elibc_musl)
		-DLIBCXX_HAS_GCC_S_LIB=OFF
		-DLIBCXX_INCLUDE_TESTS=OFF
	)

	cmake-utils_src_configure
	cmake-utils_src_compile
}

multilib_src_test() {
	local clang_path=$(type -P "${CHOST:+${CHOST}-}clang" 2>/dev/null)

	[[ -n ${clang_path} ]] || die "Unable to find ${CHOST}-clang for tests"
	sed -i -e "/cxx_under_test/s^\".*\"^\"${clang_path}\"^" test/lit.site.cfg || die

	# build a local copy of libc++ for testing to avoid circular dep
	build_libcxx
	mv "${BUILD_DIR}"/libcxx/lib/libc++* "${BUILD_DIR}/$(get_libdir)/" || die

	cmake-utils_src_make check-libcxxabi
}

multilib_src_install_all() {
	insinto /usr/include/libcxxabi
	doins -r include/.
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
CMAKE_MIN_VERSION=3.4.3
PYTHON_COMPAT=( python2_7 )

inherit cmake-multilib python-any-r1

DESCRIPTION="Low level support for a standard C++ library"
HOMEPAGE="http://libcxxabi.llvm.org/"
# also needs libcxx sources for headers
SRC_URI="http://llvm.org/releases/${PV}/${P}.src.tar.xz
	http://llvm.org/releases/${PV}/${P/abi/}.src.tar.xz"
LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="elibc_musl libunwind +static-libs test"

RDEPEND="
	libunwind? (
		|| (
			>=sys-libs/libunwind-1.0.1-r1[static-libs?,${MULTILIB_USEDEP}]
			>=sys-libs/llvm-libunwind-3.9.0-r1[static-libs?,${MULTILIB_USEDEP}]
		)
	)"
DEPEND="${RDEPEND}
	>=sys-devel/llvm-3.9.0
	test? ( >=sys-devel/clang-3.9.0
		~sys-libs/libcxx-${PV}[libcxxabi(-)]
		$(python_gen_any_dep 'dev-python/lit[${PYTHON_USEDEP}]') )"

S=${WORKDIR}/${P}.src

python_check_deps() {
	has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	default

	# backport cmake path fix for llvm-3.9+
	eapply "${FILESDIR}/${P}-cmake-path.patch"
	# kill stray unwind test dep in stand-alone builds
	eapply "${FILESDIR}/${P}-test-unwind.patch"
}

src_configure() {
	NATIVE_LIBDIR=$(get_libdir)
	cmake-multilib_src_configure
}

multilib_src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLLVM_LIBDIR_SUFFIX=${NATIVE_LIBDIR#lib}
		-DLIBCXXABI_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBCXXABI_ENABLE_SHARED=ON
		-DLIBCXXABI_ENABLE_STATIC=$(usex static-libs)
		-DLIBCXXABI_USE_LLVM_UNWINDER=$(usex libunwind)
		-DLLVM_INCLUDE_TESTS=$(usex test)

		-DLIBCXXABI_LIBCXX_INCLUDES="${WORKDIR}"/libcxx-${PV}.src/include
		# upstream is omitting standard search path for this
		# probably because gcc & clang are bundling their own unwind.h
		-DLIBCXXABI_LIBUNWIND_INCLUDES="${EPREFIX}"/usr/include
		# this only needs to exist, it does not have to make sense
		-DLIBCXXABI_LIBUNWIND_SOURCES="${T}"
	)
	if use test; then
		mycmakeargs+=(
			-DLIT_COMMAND="${EPREFIX}"/usr/bin/lit
		)
	fi
	if use elibc_musl; then
		local -x CPPFLAGS="${CPPFLAGS} -D_LIBCPP_HAS_MUSL_LIBC=1"
	fi
	cmake-utils_src_configure
}

multilib_src_test() {
	local clang_path=$(type -P "${CHOST:+${CHOST}-}clang" 2>/dev/null)

	[[ -n ${clang_path} ]] || die "Unable to find ${CHOST}-clang for tests"
	sed -i -e "/cxx_under_test/s^\".*\"^\"${clang_path}\"^" test/lit.site.cfg || die

	cmake-utils_src_make check-libcxxabi
}

multilib_src_install_all() {
	insinto /usr/include/libcxxabi
	doins -r include/.
}

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
# (needed due to CMAKE_BUILD_TYPE != Gentoo)
CMAKE_MIN_VERSION=3.7.0-r1
PYTHON_COMPAT=( python2_7 )

inherit cmake-multilib git-r3 python-any-r1

DESCRIPTION="Low level support for a standard C++ library"
HOMEPAGE="http://libcxxabi.llvm.org/"
SRC_URI=""
EGIT_REPO_URI="http://llvm.org/git/libcxxabi.git
	https://github.com/llvm-mirror/libcxxabi.git"

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS=""
IUSE="+libunwind +static-libs test"

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
		~sys-libs/libcxx-${PV}[libcxxabi(-)]
		$(python_gen_any_dep 'dev-python/lit[${PYTHON_USEDEP}]') )"

# least intrusive of all
CMAKE_BUILD_TYPE=RelWithDebInfo

python_check_deps() {
	has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_unpack() {
	# we need the headers
	git-r3_fetch "http://llvm.org/git/libcxx.git
		https://github.com/llvm-mirror/libcxx.git"
	git-r3_fetch

	git-r3_checkout http://llvm.org/git/libcxx.git \
		"${WORKDIR}"/libcxx
	git-r3_checkout
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
		mycmakeargs+=(
			-DLIT_COMMAND="${EPREFIX}"/usr/bin/lit
		)
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

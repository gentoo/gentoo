# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
# (needed due to CMAKE_BUILD_TYPE != Gentoo)
CMAKE_MIN_VERSION=3.7.0-r1
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
inherit cmake-multilib git-r3 llvm python-any-r1

DESCRIPTION="C++ runtime stack unwinder from LLVM"
HOMEPAGE="https://github.com/llvm-mirror/libunwind"
SRC_URI=""
EGIT_REPO_URI="https://git.llvm.org/git/libunwind.git
	https://github.com/llvm-mirror/libunwind.git"

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS=""
IUSE="debug +static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="!sys-libs/libunwind"
# llvm-6 for new lit options
DEPEND="
	>=sys-devel/llvm-6
	test? (
		sys-libs/libcxx[${MULTILIB_USEDEP}]
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
	# we need headers & test utilities
	git-r3_fetch "https://git.llvm.org/git/libcxx.git
		https://github.com/llvm-mirror/libcxx.git"
	git-r3_fetch

	if use test; then
		git-r3_checkout https://llvm.org/git/libcxx.git \
			"${WORKDIR}"/libcxx '' include utils/libcxx
		git-r3_checkout
	fi
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
		mycmakeargs+=(
			-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
			-DLLVM_LIT_ARGS="-vv"
			-DLIBUNWIND_LIBCXX_PATH="${WORKDIR}"/libcxx
		)
	fi

	cmake-utils_src_configure
}

multilib_src_test() {
	cmake-utils_src_make check-unwind
}

multilib_src_install() {
	cmake-utils_src_install

	# install headers like sys-libs/libunwind
	doheader "${S}"/include/*.h
}

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
# (needed due to CMAKE_BUILD_TYPE != Gentoo)
CMAKE_MIN_VERSION=3.7.0-r1
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils git-r3 llvm python-any-r1

DESCRIPTION="The LLVM linker (link editor)"
HOMEPAGE="https://llvm.org/"
SRC_URI=""
EGIT_REPO_URI="https://git.llvm.org/git/lld.git
	https://github.com/llvm-mirror/lld.git"
EGIT_BRANCH="release_60"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS=""
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="~sys-devel/llvm-${PV}"
DEPEND="${RDEPEND}
	test? ( $(python_gen_any_dep "~dev-python/lit-${PV}[\${PYTHON_USEDEP}]") )"

# least intrusive of all
CMAKE_BUILD_TYPE=RelWithDebInfo

python_check_deps() {
	has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	LLVM_MAX_SLOT=${PV%%.*} llvm_pkg_setup
	use test && python-any-r1_pkg_setup
}

src_unpack() {
	if use test; then
		# needed for patched gtest
		git-r3_fetch "https://git.llvm.org/git/llvm.git
			https://github.com/llvm-mirror/llvm.git"
	fi
	git-r3_fetch

	if use test; then
		git-r3_checkout https://llvm.org/git/llvm.git \
			"${WORKDIR}"/llvm '' utils/{lit,unittest}
	fi
	git-r3_checkout
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON

		-DLLVM_INCLUDE_TESTS=$(usex test)
	)
	use test && mycmakeargs+=(
		-DLLVM_BUILD_TESTS=ON
		-DLLVM_MAIN_SRC_DIR="${WORKDIR}/llvm"
		-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
		-DLLVM_LIT_ARGS="-vv"
	)

	cmake-utils_src_configure
}

src_test() {
	cmake-utils_src_make check-lld
}

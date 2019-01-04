# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils llvm

DESCRIPTION="Symbolic virtual machine built on top of the LLVM compiler infrastructure"
HOMEPAGE="http://klee.github.io/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/klee/${PN}.git"
else
	SRC_URI="https://github.com/klee/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="BSD-4 UoI-NCSA"
SLOT="0"
IUSE="doc +stp tcmalloc test z3 zlib"
RESTRICT="!test? ( test )"

RDEPEND="
	sys-devel/llvm:*
	sys-devel/clang:*
	stp? ( dev-libs/stp )
	tcmalloc? ( dev-util/google-perftools )
	z3? ( sci-mathematics/z3 )
"
LLVM_MAX_SLOT=8

DEPEND="
	${RDEPEND}
"

src_configure() {
	local mycmakeargs=(
		"-DKLEE_RUNTIME_BUILD_TYPE=Release"
		"-DENABLE_DOCS=$(usex doc)"
		"-DENABLE_SYSTEM_TESTS=$(usex test)"
		"-DENABLE_UNIT_TESTS=$(usex test)"
		"-DENABLE_SOLVER_STP=$(usex stp)"
		"-DENABLE_SOLVER_Z3=$(usex z3)"
		"-DENABLE_TCMALLOC=$(usex tcmalloc)"
		"-DENABLE_ZLIB=$(usex zlib)"
	)
	CMAKE_BUILD_TYPE="Release"
	cmake-utils_src_configure
}

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="Release"
LLVM_COMPAT=( {15..17} )
MY_PN="${PN/intel-/}"
MY_P="${MY_PN}-${PV}"
PYTHON_COMPAT=( python3_{10..12} )

inherit cmake llvm-r1 python-any-r1

DESCRIPTION="A set of new intrinsics on top of core LLVM IR instructions"
HOMEPAGE="https://github.com/intel/vc-intrinsics"
SRC_URI="https://github.com/intel/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-libs/libxml2:2=
	$(llvm_gen_dep '
		sys-devel/llvm:${LLVM_SLOT}
	')
	sys-libs/zlib
"
RDEPEND="${DEPEND}"
BDEPEND="${PYTHON_DEPS}"

src_configure() {
	local mycmakeargs=(
		-DLLVM_DIR="$(get_llvm_prefix)"
	)

	cmake_src_configure
}

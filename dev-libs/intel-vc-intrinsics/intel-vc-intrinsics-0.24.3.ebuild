# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="Release"
LLVM_COMPAT=( {15..20} )
MY_PN="${PN/intel-/}"
MY_P="${MY_PN}-${PV}"
PYTHON_COMPAT=( python3_{11..14} )

inherit cmake llvm-r2 python-any-r1

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
		llvm-core/llvm:${LLVM_SLOT}
	')
	virtual/zlib:=
"
RDEPEND="${DEPEND}"
BDEPEND="${PYTHON_DEPS}"

src_configure() {
	local mycmakeargs=(
		-DLLVM_DIR="$(get_llvm_prefix)"
	)

	cmake_src_configure
}

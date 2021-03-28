# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCm-CompilerSupport/"
	inherit git-r3
	S="${WORKDIR}/${P}/lib/comgr"
else
	SRC_URI="https://github.com/RadeonOpenCompute/ROCm-CompilerSupport/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/ROCm-CompilerSupport-rocm-${PV}/lib/comgr"
	KEYWORDS="~amd64"
fi

PATCHES=(
	"${FILESDIR}/${PN}-3.1.0-dependencies.patch"
)

DESCRIPTION="Radeon Open Compute Code Object Manager"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-CompilerSupport"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

RDEPEND=">=dev-libs/rocm-device-libs-${PV}
	>=sys-devel/llvm-roc-${PV}:="
DEPEND="${RDEPEND}"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DLLD_DIR="${EPREFIX}/usr/lib/llvm/roc/lib/cmake/lld"
		-DLLVM_DIR="${EPREFIX}/usr/lib/llvm/roc/lib/cmake/llvm"
		-DClang_DIR="${EPREFIX}/usr/lib/llvm/roc/lib/cmake/clang"
	)
	cmake_src_configure
}

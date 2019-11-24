# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCm-Device-Libs/"
	inherit git-r3
	S="${WORKDIR}/${P}/src"
else
	SRC_URI="https://github.com/RadeonOpenCompute/ROCm-Device-Libs/archive/roc-ocl-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/ROCm-Device-Libs-roc-ocl-${PV}"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Radeon Open Compute Device Libraries"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-Device-Libs"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

RDEPEND=">=dev-libs/rocr-runtime-${PV}
	>=sys-devel/llvm-roc-${PV}:="
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DLLVM_DIR="${EPREFIX}/usr/lib/llvm/roc/"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/"
	)
	cmake-utils_src_configure
}

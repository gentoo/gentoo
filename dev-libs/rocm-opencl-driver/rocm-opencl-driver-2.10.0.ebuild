# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Driver/"
	inherit git-r3
else
	SRC_URI="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Driver/archive/roc-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/ROCm-OpenCL-Driver-roc-${PV}"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Radeon Open Compute OpenCL Compiler Tool Driver"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Driver"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
IUSE="test"

RDEPEND=">=sys-devel/llvm-roc-${PV}:=
	>=dev-libs/rocr-runtime-${PV}"
DEPEND="${RDEPEND}"
RESTRICT="!test? ( test )"

src_prepare() {
	# remove unittest, because it downloads additional file from github.com
	sed -e "s:add_subdirectory(src/unittest):#add_subdirectory(src/unittest):" -i CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DLLVM_DIR="${EPREFIX}/usr/lib/llvm/roc/"
	)
	cmake_src_configure
}

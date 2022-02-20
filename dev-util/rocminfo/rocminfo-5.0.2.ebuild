# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/rocminfo/"
	inherit git-r3
else
	SRC_URI="https://github.com/RadeonOpenCompute/rocminfo/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/rocminfo-rocm-${PV}"
fi

DESCRIPTION="ROCm Application for Reporting System Info"
HOMEPAGE="https://github.com/RadeonOpenCompute/rocminfo"
LICENSE="UoI-NCSA"
SLOT="0/$(ver_cut 1-2)"

RDEPEND=">=dev-libs/rocr-runtime-${PV}"
DEPEND="${RDEPEND}"

PATCHES=("${FILESDIR}/${PN}-4.3.0-detect-builtin-amdgpu.patch")

src_prepare()
{
	sed -e "/CPACK_RESOURCE_FILE_LICENSE/d" -i CMakeLists.txt || die
	cmake_src_prepare
}

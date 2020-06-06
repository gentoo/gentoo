# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCR-Runtime/"
	inherit git-r3
	S="${WORKDIR}/${P}/src"
else
	SRC_URI="https://github.com/RadeonOpenCompute/ROCR-Runtime/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/ROCR-Runtime-rocm-${PV}/src"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Radeon Open Compute Runtime"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCR-Runtime"
PATCHES=(
	"${FILESDIR}/${PN}-3.5.0-cmake-install-paths.patch"
)

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
IUSE="non-free"

COMMON_DEPEND="sys-process/numactl"
RDEPEND="${COMMON_DEPEND}
	non-free? ( dev-libs/hsa-ext-rocr )"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/roct-thunk-interface-${PV}"

src_prepare() {
	sed -e "s:get_version ( \"1.0.0\" ):get_version ( \"${PV}\" ):" -i CMakeLists.txt || die
	cmake_src_prepare
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="ROCm Communication Collectives Library (RCCL)"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rccl"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rccl/archive/rocm-${PV}.tar.gz -> rccl-${PV}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"

RDEPEND="dev-util/hip:${SLOT}"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-util/cmake-3.22
	>=dev-util/rocm-cmake-5.0.2-r1"

S="${WORKDIR}/rccl-rocm-${PV}"

PATCHES=(
	"${FILESDIR}/rccl-5.0.2-change_install_location.patch"
)

src_configure() {
	addwrite /dev/kfd
	addpredict /dev/dri/

	export DEVICE_LIB_PATH="${EPREFIX}/usr/lib/amdgcn/bitcode/"
	export CXX=hipcc

	local mycmakeargs=(
		-DBUILD_TESTS=OFF
		-Wno-dev
		${AMDGPU_TARGETS+-DAMDGPU_TARGETS="${AMDGPU_TARGETS}"}
	)

	cmake_src_configure
}

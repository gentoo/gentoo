# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}

inherit cmake rocm

DESCRIPTION="CU / ROCM agnostic hip RAND implementation"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipRAND"
SRC_URI="https://github.com/ROCmSoftwarePlatform/hipRAND/archive/refs/tags/rocm-${PV}.tar.gz -> hipRAND-rocm-${PV}.tar.gz"
REQUIRED_USE="${ROCM_REQUIRED_USE}"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"

RESTRICT="test"

RDEPEND="dev-util/hip
	sci-libs/rocRAND:${SLOT}[${ROCM_USEDEP}]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/hipRAND-rocm-${PV}"

src_configure() {
	local mycmakeargs=(
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DROCM_SYMLINK_LIBS=OFF
	)

	CXX=hipcc cmake_src_configure
}

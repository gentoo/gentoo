# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}

inherit cmake rocm

DESCRIPTION="CU / ROCM agnostic marshalling library for LAPACK routines on the GPU"
HOMEPAGE="https://github.com/ROCm/hipSOLVER"
SRC_URI="https://github.com/ROCm/hipSOLVER/archive/refs/tags/rocm-${PV}.tar.gz -> hipSOLVER-rocm-${PV}.tar.gz"
S="${WORKDIR}/hipSOLVER-rocm-${PV}"

REQUIRED_USE="${ROCM_REQUIRED_USE}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="sparse"

RESTRICT="test"

RDEPEND="
	dev-util/hip
	sci-libs/rocSOLVER:${SLOT}[${ROCM_USEDEP}]
	sparse? (
		sci-libs/suitesparseconfig
		sci-libs/cholmod
	)
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-6.1.1-find-cholmod.patch
)

src_configure() {
	rocm_use_hipcc

	local mycmakeargs=(
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DROCM_SYMLINK_LIBS=OFF
		-DBUILD_WITH_SPARSE=$(usex sparse ON OFF)
	)

	cmake_src_configure
}

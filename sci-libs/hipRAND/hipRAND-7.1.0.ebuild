# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}

inherit cmake rocm

DESCRIPTION="CU / ROCM agnostic hip RAND implementation"
HOMEPAGE="https://github.com/ROCm/rocm-libraries/tree/develop/projects/hiprand"
SRC_URI="https://github.com/ROCm/hipRAND/archive/refs/tags/rocm-${PV}.tar.gz -> hipRAND-rocm-${PV}.tar.gz"
S="${WORKDIR}/hipRAND-rocm-${PV}"

REQUIRED_USE="${ROCM_REQUIRED_USE}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

RESTRICT="test"

RDEPEND="sci-libs/rocRAND:${SLOT}"
DEPEND="
	${RDEPEND}
	dev-util/hip:${SLOT}
"

src_configure() {
	rocm_use_clang

	local mycmakeargs=(
		-Wno-dev
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DROCM_SYMLINK_LIBS=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_Git=ON
	)

	cmake_src_configure
}

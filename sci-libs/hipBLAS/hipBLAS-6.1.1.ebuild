# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}

inherit cmake rocm
DESCRIPTION="ROCm BLAS marshalling library"
HOMEPAGE="https://github.com/ROCm/hipBLAS"
SRC_URI="https://github.com/ROCm/hipBLAS/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/hipBLAS-rocm-${PV}"

REQUIRED_USE="${ROCM_REQUIRED_USE}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

RDEPEND="dev-util/hip
	sci-libs/rocBLAS:${SLOT}[${ROCM_USEDEP}]
	sci-libs/rocSOLVER:${SLOT}[${ROCM_USEDEP}]"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		# currently hipBLAS is a wrapper of rocBLAS which has tests, so no need to perform test here
		-DBUILD_CLIENTS_TESTS=OFF
		-DBUILD_CLIENTS_BENCHMARKS=OFF
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DROCM_SYMLINK_LIBS=OFF
	)

	cmake_src_configure
}

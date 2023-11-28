# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}

inherit cmake edo rocm

DESCRIPTION="Implementation of a subset of LAPACK functionality on the ROCm platform"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocSOLVER"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocSOLVER/archive/rocm-${PV}.tar.gz -> rocSOLVER-${PV}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"

IUSE="test benchmark"
REQUIRED_USE="${ROCM_REQUIRED_USE}"

RDEPEND="dev-util/hip
	sci-libs/rocBLAS:${SLOT}[${ROCM_USEDEP}]
	sci-libs/rocSPARSE:${SLOT}[${ROCM_USEDEP}]
	dev-libs/libfmt
	benchmark? ( virtual/blas )"
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-cpp/gtest
	>=dev-util/cmake-3.22
	virtual/blas )"

RESTRICT="!test? ( test )"

S=${WORKDIR}/${PN}-rocm-${PV}

src_configure() {
	# avoid sandbox violation
	addpredict /dev/kfd
	addpredict /dev/dri/

	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=On
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-Wno-dev
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DROCM_SYMLINK_LIBS=OFF
		-DBUILD_CLIENTS_SAMPLES=NO
		-DBUILD_CLIENTS_TESTS=$(usex test ON OFF)
		-DBUILD_CLIENTS_BENCHMARKS=$(usex benchmark ON OFF)
	)

	CXX=hipcc cmake_src_configure
}

src_test() {
	check_amdgpu
	cd "${BUILD_DIR}"/clients/staging || die
	LD_LIBRARY_PATH="${BUILD_DIR}/library/src" edob ./rocsolver-test
}

src_install() {
	cmake_src_install

	if use benchmark; then
		cd "${BUILD_DIR}" || die
		dobin clients/staging/rocsolver-bench
	fi
}

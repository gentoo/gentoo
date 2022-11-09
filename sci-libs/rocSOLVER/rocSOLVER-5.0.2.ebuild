# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Implementation of a subset of LAPACK functionality on the ROCm platform"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocSOLVER"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocSOLVER/archive/rocm-${PV}.tar.gz -> rocSOLVER-${PV}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"

IUSE="test benchmark"

RDEPEND="dev-util/hip
	sci-libs/rocBLAS:${SLOT}
	=dev-libs/libfmt-8*
	benchmark? ( virtual/blas )"
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-cpp/gtest
	>=dev-util/cmake-3.22
	virtual/blas )"

PATCHES=(
	"${FILESDIR}/${PN}-4.2.0-add-stdint-header.patch"
	"${FILESDIR}/${P}-libfmt8.patch"
)

RESTRICT="!test? ( test )"

S=${WORKDIR}/${PN}-rocm-${PV}

src_prepare() {
	sed -e "s: PREFIX rocsolver:# PREFIX rocsolver:" -i library/src/CMakeLists.txt
	sed -e "s:\$<INSTALL_INTERFACE\:include>:\$<INSTALL_INTERFACE\:include/rocsolver>:" -i library/src/CMakeLists.txt
	sed -e "s:rocm_install_symlink_subdir( rocsolver ):#rocm_install_symlink_subdir( rocsolver ):" -i library/src/CMakeLists.txt

	cmake_src_prepare
}

src_configure() {
	# Grant access to the device
	addwrite /dev/kfd
	addpredict /dev/dri/

	local mycmakeargs=(
		-Wno-dev
		-DCMAKE_SKIP_RPATH=ON
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/"
		-DCMAKE_INSTALL_INCLUDEDIR="${EPREFIX}/usr/include/rocsolver"
		-DBUILD_CLIENTS_SAMPLES=NO
		-DBUILD_CLIENTS_TESTS=$(usex test ON OFF)
		-DBUILD_CLIENTS_BENCHMARKS=$(usex benchmark ON OFF)
		${AMDGPU_TARGETS+-DAMDGPU_TARGETS="${AMDGPU_TARGETS}"}
	)

	CXX="hipcc" cmake_src_configure
}

src_test() {
	addwrite /dev/kfd
	addwrite /dev/dri/
	cd "${BUILD_DIR}/clients/staging" || die
	LD_LIBRARY_PATH="${BUILD_DIR}/library/src" ./rocsolver-test || die
}

src_install() {
	cmake_src_install

	if use benchmark; then
		cd "${BUILD_DIR}" || die
		dobin clients/staging/rocsolver-bench
	fi
}

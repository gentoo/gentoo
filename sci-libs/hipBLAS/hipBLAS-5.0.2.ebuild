# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake
DESCRIPTION="ROCm BLAS marshalling library"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipBLAS"
SRC_URI="https://github.com/ROCmSoftwarePlatform/hipBLAS/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"

RDEPEND="dev-util/hip
	sci-libs/rocBLAS:${SLOT}
	sci-libs/rocSOLVER:${SLOT}"
DEPEND="${RDEPEND}"
BDEPEND=""

S="${WORKDIR}/hipBLAS-rocm-${PV}"

src_prepare() {
	sed -e "s:<INSTALL_INTERFACE\:include:<INSTALL_INTERFACE\:include/hipblas/:" -i library/src/CMakeLists.txt || die
	sed -e "/PREFIX hipblas/d" -i library/src/CMakeLists.txt || die
	sed -e "/rocm_install_symlink_subdir( hipblas )/d" -i library/src/CMakeLists.txt || die
	sed -e "s:hipblas/include:include/hipblas:" -i library/src/CMakeLists.txt || die

	eapply_user
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_SKIP_RPATH=ON
		-DBUILD_CLIENTS_TESTS=OFF  # currently hipBLAS is a wrapper of rocBLAS which has tests, so no need to perform test here
		-DBUILD_CLIENTS_BENCHMARKS=OFF
	)

	cmake_src_configure
}

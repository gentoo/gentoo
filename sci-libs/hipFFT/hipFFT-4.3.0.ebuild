# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic

DESCRIPTION="CU / ROCM agnostic hip FFT implementation"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipFFT"
SRC_URI="https://github.com/ROCmSoftwarePlatform/hipFFT/archive/refs/tags/rocm-${PV}.tar.gz -> hipFFT-rocm-${PV}.tar.gz
	test? ( https://github.com/ROCmSoftwarePlatform/rocFFT/archive/rocm-${PV}.tar.gz -> rocFFT-${PV}.tar.gz )"

LICENSE="MIT"
KEYWORDS="~amd64"
IUSE="benchmark test"
SLOT="0/$(ver_cut 1-2)"

RESTRICT="!test? ( test )"

RDEPEND="dev-util/hip:${SLOT}
	sci-libs/rocFFT:${SLOT}"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		dev-cpp/gtest
		dev-libs/boost
)"

S="${WORKDIR}/hipFFT-rocm-${PV}"

PATCHES=(
	"${FILESDIR}/${PN}-4.3.0-gentoo-install-locations.patch"
	"${FILESDIR}/${PN}-4.3.0-remove-git-dependency.patch"
	"${FILESDIR}/${PN}-4.3.0-add-complex-header.patch"
)

src_prepare() {
	use test && rmdir rocFFT && ln -s ../rocFFT-rocm-${PV} rocFFT
	eapply_user
	cmake_src_prepare
}

src_configure() {
	# Grant access to the device
	addwrite /dev/kfd
	addpredict /dev/dri/

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_INSTALL_INCLUDEDIR="include/hipfft"
		-DCMAKE_SKIP_RPATH=ON
		-DBUILD_CLIENTS_TESTS=$(usex test ON OFF)
		-DBUILD_CLIENTS_RIDER=$(usex benchmark ON OFF)
		${AMDGPU_TARGETS+-DAMDGPU_TARGETS="${AMDGPU_TARGETS}"}
		-D__skip_rocmclang="ON" ## fix cmake-3.21 configuration issue caused by officialy support programming language "HIP"
	)

	cmake_src_configure
}

src_test () {
	addwrite /dev/kfd
	addpredict /dev/dri
	cd "${BUILD_DIR}/clients/staging" || die
	einfo "Running hipfft-test"
	LD_LIBRARY_PATH=${BUILD_DIR}/library ./hipfft-test || die
}

src_install() {
	cmake_src_install
	if use benchmark; then
		cd "${BUILD_DIR}/clients/staging" || die
		dobin hipfft-rider
	fi
}

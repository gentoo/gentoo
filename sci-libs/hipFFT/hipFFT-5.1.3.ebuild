# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}

inherit cmake rocm

DESCRIPTION="CU / ROCM agnostic hip FFT implementation"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipFFT"
SRC_URI="https://github.com/ROCmSoftwarePlatform/hipFFT/archive/refs/tags/rocm-${PV}.tar.gz -> hipFFT-rocm-${PV}.tar.gz"
REQUIRED_USE="${ROCM_REQUIRED_USE}"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"

RESTRICT="test"

RDEPEND="dev-util/hip:${SLOT}
	sci-libs/rocFFT:${SLOT}[${ROCM_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND=""

S="${WORKDIR}/hipFFT-rocm-${PV}"

PATCHES=(
	"${FILESDIR}/${PN}-5.1.3-gentoo-install-locations.patch"
	"${FILESDIR}/${PN}-5.0.2-remove-git-dependency.patch"
	"${FILESDIR}/${PN}-4.3.0-add-complex-header.patch"
)

src_prepare() {
	sed -e "/CMAKE_INSTALL_LIBDIR/d" -i CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_INSTALL_INCLUDEDIR="include/hipfft"
		-DCMAKE_MODULE_PATH="${EPREFIX}/usr/$(get_libdir)/cmake"
		-DHIP_ROOT_DIR="${EPREFIX}/usr"
		-DBUILD_CLIENTS_TESTS=OFF
		-DBUILD_CLIENTS_RIDER=OFF
	)

	cmake_src_configure
}

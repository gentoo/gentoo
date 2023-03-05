# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}

inherit cmake rocm

DESCRIPTION="CU / ROCM agnostic hip FFT implementation"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipFFT"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipSPARSE"
if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_SUBMODULES=()
	EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/hipFFT.git"
	S="${WORKDIR}/${P}"
else
	S="${WORKDIR}/${PN}-rocm-${PV}"
	SRC_URI="https://github.com/ROCmSoftwarePlatform/hipFFT/archive/refs/tags/rocm-${PV}.tar.gz -> hipFFT-rocm-${PV}.tar.gz"
	KEYWORDS="~amd64"
fi
REQUIRED_USE="${ROCM_REQUIRED_USE}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

RESTRICT="test"

RDEPEND="dev-util/hip:${SLOT}
	sci-libs/rocFFT:${SLOT}[${ROCM_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND=""

PATCHES=(
	"${FILESDIR}/${PN}-4.3.0-add-complex-header.patch"
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DROCM_SYMLINK_LIBS=OFF
		-DCMAKE_MODULE_PATH="${EPREFIX}/usr/$(get_libdir)/cmake/hip"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DHIP_ROOT_DIR="${EPREFIX}/usr"
		-DBUILD_CLIENTS_TESTS=OFF
		-DBUILD_CLIENTS_RIDER=OFF
	)

	ROCM_PATH="${EPREFIX}/usr" cmake_src_configure
}

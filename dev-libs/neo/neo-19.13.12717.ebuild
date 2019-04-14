# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib

MAJOR_PV=$(ver_cut 1)

DESCRIPTION="Intel(R) Graphics Compute Runtime for OpenCL (Beignet replacement)"
HOMEPAGE="https://01.org/compute-runtime https://github.com/intel/compute-runtime"
SRC_URI="https://github.com/intel/compute-runtime/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="=media-libs/gmmlib-${MAJOR_PV}*[${MULTILIB_USEDEP}]
	>=x11-libs/libva-2[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	x11-libs/libdrm"
# ^ from libdrm we only need the headers
RDEPEND="${COMMON_DEPEND}
	dev-libs/ocl-icd[${MULTILIB_USEDEP}]"
BDEPEND="=dev-util/igc-1*"

PATCHES=(
	"${FILESDIR}/${P}-gentoo.patch"
	)

S="${WORKDIR}/compute-runtime-${PV}"

# dev-libs/ocl-icd[khronos-headers] does not provide all the headers we need
# media-libs/mesa seems to provide the Khronos OpenGL headers. TODO: verify, then add
#   -DKHRONOS_GL_HEADERS_DIR="${EPREFIX}/usr/include"
multilib_src_configure() {
	local mycmakeargs=(
		-DIGDRCL_FORCE_USE_LIBVA=ON
		-DLIBDRM_DIR="${EPREFIX}/usr"
		-DICD_SUFFIX="-${ABI}"  # introduced by patch
	)

	multilib_is_native_abi && mycmakeargs+=(-DBUILD_OCL=ON)  # introduced by patch

	cmake-utils_src_configure
}

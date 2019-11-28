# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

MY_PN="compute-runtime"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Intel Graphics Compute Runtime for OpenCL, for Gen8 (Broadwell) and beyond"
HOMEPAGE="https://github.com/intel/compute-runtime"
SRC_URI="https://github.com/intel/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="vaapi"

BDEPEND="virtual/pkgconfig"
COMMON="dev-libs/ocl-icd
	>=dev-util/intel-graphics-compiler-1.0.2878
	>=media-libs/gmmlib-19.3.4
	vaapi? (
		x11-libs/libdrm[video_cards_intel]
		>=x11-libs/libva-2.0.0
	)"
DEPEND="${COMMON}
	media-libs/mesa"	# for Khronos OpenGL headers
RDEPEND="${COMMON}"

DOCS=(
	README.md
	documentation/FAQ.md
	documentation/LIMITATIONS.md
)

S="${WORKDIR}"/${MY_P}

src_configure() {
	local mycmakeargs=(
		-DKHRONOS_GL_HEADERS_DIR="${EPREFIX}/usr/include"
		-DDISABLE_LIBVA=$(usex vaapi "OFF" "ON")
		# If enabled, tests are automatically run during the compile phase
		# - and we cannot run them because they require permissions to access
		# the hardware.
		-DSKIP_UNIT_TESTS=ON
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	"${ROOT}"/usr/bin/eselect opencl set --use-old ocl-icd
}

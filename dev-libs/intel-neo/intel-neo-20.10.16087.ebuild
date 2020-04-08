# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

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
COMMON=">=virtual/opencl-3
	>=dev-util/intel-graphics-compiler-1.0.3445
	>=media-libs/gmmlib-19.4.1
	vaapi? (
		x11-libs/libdrm[video_cards_intel]
		x11-libs/libva
	)"
DEPEND="${COMMON}
	media-libs/mesa"	# for Khronos OpenGL headers
RDEPEND="${COMMON}"

DOCS=(
	README.md
	FAQ.md
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
	cmake_src_configure
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

MY_PN="compute-runtime"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Intel Graphics Compute Runtime for L0 and OpenCL, for Broadwell and beyond"
HOMEPAGE="https://github.com/intel/compute-runtime"
SRC_URI="https://github.com/intel/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="l0 vaapi"

RDEPEND="
	>=dev-util/intel-graphics-compiler-1.0.8365
	>=media-libs/gmmlib-21.2.1
	>=virtual/opencl-3
	l0? ( >=dev-libs/level-zero-1.4.1 )
	vaapi? (
		x11-libs/libdrm[video_cards_intel]
		x11-libs/libva
	)
"

# for Khronos OpenGL headers
DEPEND="
	${RDEPEND}
	media-libs/mesa
"

BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-21.31.20514-no_Werror.patch )

DOCS=( "README.md" "FAQ.md" )

src_configure() {
	local mycmakeargs=(
		-DKHRONOS_GL_HEADERS_DIR="${ESYSROOT}/usr/include"
		-DOCL_ICD_VENDORDIR="${EPREFIX}/etc/OpenCL/vendors"
		-DBUILD_WITH_L0=$(usex l0)
		-DDISABLE_LIBVA=$(usex vaapi "no" "yes")
		# If enabled, tests are automatically run during the compile phase
		# - and we cannot run them because they require permissions to access
		# the hardware.
		-DSKIP_UNIT_TESTS=ON
	)

	cmake_src_configure
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

MY_PN="compute-runtime"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Intel Graphics Compute Runtime for L0 and OpenCL, for Broadwell and beyond"
HOMEPAGE="https://github.com/intel/compute-runtime"
SRC_URI="https://github.com/intel/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="l0 vaapi"

BDEPEND="virtual/pkgconfig"
COMMON=">=virtual/opencl-3
	>=dev-util/intel-graphics-compiler-1.0.5353
	>=media-libs/gmmlib-20.3.2
	l0? ( >=dev-libs/level-zero-1.0.0 )
	vaapi? (
		x11-libs/libdrm[video_cards_intel]
		x11-libs/libva
	)"
DEPEND="${COMMON}
	media-libs/mesa"	# for Khronos OpenGL headers
RDEPEND="${COMMON}"

PATCHES=(
	"${FILESDIR}"/${PN}-20.37.17906-no_Werror.patch
)

DOCS=(
	README.md
	FAQ.md
)

S="${WORKDIR}"/${MY_P}

src_configure() {
	local mycmakeargs=(
		-DKHRONOS_GL_HEADERS_DIR="${EPREFIX}/usr/include"
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

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="Release"
MY_PN="${PN/intel-/}"
MY_P="${MY_PN}-${PV}"

inherit cmake

DESCRIPTION="Intel Graphics Compute Runtime for oneAPI Level Zero and OpenCL Driver"
HOMEPAGE="https://github.com/intel/compute-runtime"
SRC_URI="https://github.com/intel/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+l0 +vaapi"

RDEPEND=">=media-libs/gmmlib-22.0.2:="

DEPEND="
	${DEPEND}
	dev-libs/intel-metrics-library
	dev-libs/libnl:3
	dev-libs/libxml2:2
	>=dev-util/intel-graphics-compiler-1.0.10713
	>=dev-util/intel-graphics-system-controller-0.2.4
	media-libs/mesa
	>=virtual/opencl-3
	l0? ( >=dev-libs/level-zero-1.7.15 )
	vaapi? (
		x11-libs/libdrm[video_cards_intel]
		x11-libs/libva
	)
"

BDEPEND="virtual/pkgconfig"

DOCS=( "README.md" "FAQ.md" )

PATCHES=( "${FILESDIR}/${PN}-22.12.22749-metrics.patch" )

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_INSTALL_LIBDIR="$(get_libdir)"
		-DBUILD_WITH_L0="$(usex l0)"
		-DDISABLE_LIBVA="$(usex !vaapi)"
		-DNEO__METRICS_LIBRARY_INCLUDE_DIR="${ESYSROOT}/usr/include"
		-DKHRONOS_GL_HEADERS_DIR="${ESYSROOT}/usr/include"
		-DOCL_ICD_VENDORDIR="${EPREFIX}/etc/OpenCL/vendors"
		-DSUPPORT_DG1="ON"

		# See https://github.com/intel/intel-graphics-compiler/issues/204
		-DNEO_DISABLE_BUILTINS_COMPILATION="ON"

		# If enabled, tests are automatically run during
		# the compile phase and we cannot run them because
		# they require permissions to access the hardware.
		-DSKIP_UNIT_TESTS="1"

		-Wno-dev
	)

	cmake_src_configure
}

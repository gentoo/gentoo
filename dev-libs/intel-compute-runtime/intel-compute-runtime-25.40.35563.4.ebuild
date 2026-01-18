# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="Release"
MY_PN="${PN/intel-/}"
MY_P="${MY_PN}-${PV}"

inherit cmake flag-o-matic

DESCRIPTION="Intel Graphics Compute Runtime for oneAPI Level Zero and OpenCL Driver"
HOMEPAGE="https://github.com/intel/compute-runtime"
SRC_URI="https://github.com/intel/${MY_PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0/1.6.$(ver_cut 3)"
KEYWORDS="amd64"
IUSE="disable-mitigations +l0 +vaapi"

RDEPEND="
	!dev-libs/intel-compute-runtime:legacy
	>=dev-util/intel-graphics-compiler-2.23.0:0
	!dev-util/intel-graphics-compiler:legacy
	>=media-libs/gmmlib-22.7.1:=
"

DEPEND="
	${RDEPEND}
	dev-libs/intel-metrics-discovery:=
	>=dev-libs/intel-metrics-library-1.0.200:=
	dev-libs/libnl:3
	dev-libs/libxml2:2
	>=dev-util/intel-graphics-system-controller-1.0.0:=
	media-libs/mesa
	>=virtual/opencl-3
	l0? ( >=dev-libs/level-zero-1.26.0:= )
	vaapi? (
		x11-libs/libdrm[video_cards_intel]
		media-libs/libva
	)
"

BDEPEND="virtual/pkgconfig"

DOCS=( "README.md" "FAQ.md" )

src_prepare() {
	# Remove '-Werror' from default
	sed -e '/Werror/d' -i CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	# Filtered for two reasons:
	# 1) https://github.com/intel/compute-runtime/issues/528
	# 2) bug #930199
	filter-lto

	local mycmakeargs=(
		-DCCACHE_ALLOWED="OFF"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_INSTALL_LIBDIR="$(get_libdir)"
		-DBUILD_WITH_L0="$(usex l0)"
		-DDISABLE_LIBVA="$(usex !vaapi)"
		-DNEO_ALLOW_LEGACY_PLATFORMS_SUPPORT="ON"
		-DNEO_DISABLE_LTO="ON"
		-DNEO_DISABLE_MITIGATIONS="$(usex disable-mitigations)"
		-DNEO__METRICS_LIBRARY_INCLUDE_DIR="${ESYSROOT}/usr/include"
		-DKHRONOS_GL_HEADERS_DIR="${ESYSROOT}/usr/include"
		-DOCL_ICD_VENDORDIR="${EPREFIX}/etc/OpenCL/vendors"
		-DSUPPORT_DG1="ON"
		-Wno-dev

		# See https://github.com/intel/intel-graphics-compiler/issues/204
		# -DNEO_DISABLE_BUILTINS_COMPILATION="ON"

		# If enabled, tests are automatically run during
		# the compile phase and we cannot run them because
		# they require permissions to access the hardware.
		-DSKIP_UNIT_TESTS="1"
	)

	cmake_src_configure
}

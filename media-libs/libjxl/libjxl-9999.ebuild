# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3 xdg

DESCRIPTION="JPEG XL image format reference implementation"
HOMEPAGE="https://github.com/libjxl/libjxl"

EGIT_REPO_URI="https://github.com/libjxl/libjxl.git"

LICENSE="BSD"
SLOT="0"
IUSE="examples gdk-pixbuf gimp210"

DEPEND="app-arch/brotli
	dev-cpp/gflags
	dev-cpp/gtest
	dev-cpp/highway
	dev-util/google-perftools
	media-libs/freeglut
	media-libs/giflib
	media-libs/lcms
	media-libs/libpng
	media-libs/openexr:=
	sys-libs/zlib
	virtual/jpeg
	virtual/opengl
	x11-misc/shared-mime-info
	gdk-pixbuf? ( x11-libs/gdk-pixbuf:2 )
	gimp210? ( >=media-gfx/gimp-2.10.28:0/2 )
"

BDEPEND=""

RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DBUILD_TESTING=OFF
		-DJPEGXL_ENABLE_BENCHMARK=OFF
		-DJPEGXL_ENABLE_COVERAGE=OFF
		-DJPEGXL_ENABLE_FUZZERS=OFF
		-DJPEGXL_ENABLE_SJPEG=OFF
		-DJPEGXL_WARNINGS_AS_ERRORS=OFF

		-DJPEGXL_ENABLE_SKCMS=ON
		-DJPEGXL_ENABLE_EXAMPLES=$(usex examples)
		-DJPEGXL_ENABLE_VIEWERS=OFF
		-DJPEGXL_ENABLE_PLUGINS=ON
		-DJPEGXL_ENABLE_PLUGIN_GDKPIXBUF=$(usex gdk-pixbuf)
		-DJPEGXL_ENABLE_PLUGIN_GIMP210=$(usex gimp210)
		-DJPEGXL_FORCE_SYSTEM_BROTLI=ON
		-DJPEGXL_FORCE_SYSTEM_HWY=ON
		-DJPEGXL_FORCE_SYSTEM_GTEST=ON
		-DJPEGXL_FORCE_SYSTEM_LCMS2=ON
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	if use examples; then
		dobin "${BUILD_DIR}/jxlinfo"
	fi
}

# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_ECLASS=cmake
inherit cmake-multilib git-r3 xdg

DESCRIPTION="JPEG XL image format reference implementation"
HOMEPAGE="https://github.com/libjxl/libjxl"

EGIT_REPO_URI="https://github.com/libjxl/libjxl.git"
EGIT_SUBMODULES=(third_party/skcms)

LICENSE="BSD"
SLOT="0"
IUSE="examples gdk-pixbuf gimp210 openexr"

DEPEND="app-arch/brotli:=[${MULTILIB_USEDEP}]
	dev-cpp/gflags:=[${MULTILIB_USEDEP}]
	>=dev-cpp/highway-0.16.0[${MULTILIB_USEDEP}]
	media-libs/giflib:=[${MULTILIB_USEDEP}]
	media-libs/libpng:=[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	virtual/jpeg[${MULTILIB_USEDEP}]
	x11-misc/shared-mime-info
	gdk-pixbuf? (
		dev-libs/glib:2
		x11-libs/gdk-pixbuf:2
	)
	gimp210? ( >=media-gfx/gimp-2.10.28:0/2 )
	openexr? ( media-libs/openexr:= )
"

RDEPEND="${DEPEND}"

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DBUILD_TESTING=OFF
		-DJPEGXL_ENABLE_BENCHMARK=OFF
		-DJPEGXL_ENABLE_COVERAGE=OFF
		-DJPEGXL_ENABLE_FUZZERS=OFF
		-DJPEGXL_ENABLE_SJPEG=OFF
		-DJPEGXL_WARNINGS_AS_ERRORS=OFF

		-DJPEGXL_ENABLE_SKCMS=ON
		-DJPEGXL_ENABLE_VIEWERS=OFF
		-DJPEGXL_FORCE_SYSTEM_BROTLI=ON
		-DJPEGXL_FORCE_SYSTEM_HWY=ON
		-DJPEGXL_ENABLE_DOXYGEN=OFF
		-DJPEGXL_ENABLE_MANPAGES=OFF
		-DJPEGXL_ENABLE_JNI=OFF
		-DJPEGXL_ENABLE_TCMALLOC=OFF
	)

	if multilib_is_native_abi; then
		mycmakeargs+=(
			-DJPEGXL_ENABLE_TOOLS=ON
			-DJPEGXL_ENABLE_EXAMPLES=$(usex examples)
			-DJPEGXL_ENABLE_OPENEXR=$(usex openexr)
			-DJPEGXL_ENABLE_PLUGINS=ON
			-DJPEGXL_ENABLE_PLUGIN_GDKPIXBUF=$(usex gdk-pixbuf)
			-DJPEGXL_ENABLE_PLUGIN_GIMP210=$(usex gimp210)
		)
	else
		mycmakeargs+=(
			-DJPEGXL_ENABLE_TOOLS=OFF
			-DJPEGXL_ENABLE_EXAMPLES=OFF
			-DJPEGXL_ENABLE_OPENEXR=OFF
			-DJPEGXL_ENABLE_PLUGINS=OFF
		)
	fi

	cmake_src_configure
}

multilib_src_install() {
	cmake_src_install
	if use examples && multilib_is_native_abi; then
		dobin "${BUILD_DIR}/jxlinfo"
	fi
}

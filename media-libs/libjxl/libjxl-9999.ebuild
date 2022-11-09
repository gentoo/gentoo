# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib flag-o-matic git-r3

DESCRIPTION="JPEG XL image format reference implementation"
HOMEPAGE="https://github.com/libjxl/libjxl"

EGIT_REPO_URI="https://github.com/libjxl/libjxl.git"
EGIT_SUBMODULES=(third_party/skcms)

LICENSE="BSD"
SLOT="0"
IUSE="gdk-pixbuf openexr"

DEPEND="app-arch/brotli:=[${MULTILIB_USEDEP}]
	>=dev-cpp/highway-1.0.0[${MULTILIB_USEDEP}]
	media-libs/giflib:=[${MULTILIB_USEDEP}]
	media-libs/libjpeg-turbo[${MULTILIB_USEDEP}]
	media-libs/libpng:=[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	>=x11-misc/shared-mime-info-2.2
	gdk-pixbuf? (
		dev-libs/glib:2
		x11-libs/gdk-pixbuf:2
	)
	openexr? ( media-libs/openexr:= )
"
RDEPEND="${DEPEND}"

multilib_src_configure() {
	filter-lto

	local mycmakeargs=(
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
		-DJPEGXL_ENABLE_EXAMPLES=OFF
	)

	if multilib_is_native_abi; then
		mycmakeargs+=(
			-DJPEGXL_ENABLE_TOOLS=ON
			-DJPEGXL_ENABLE_OPENEXR=$(usex openexr)
			-DJPEGXL_ENABLE_PLUGINS=ON
			-DJPEGXL_ENABLE_PLUGIN_GDKPIXBUF=$(usex gdk-pixbuf)
			-DJPEGXL_ENABLE_PLUGIN_GIMP210=OFF
			-DJPEGXL_ENABLE_PLUGIN_MIME=OFF
		)
	else
		mycmakeargs+=(
			-DJPEGXL_ENABLE_TOOLS=OFF
			-DJPEGXL_ENABLE_OPENEXR=OFF
			-DJPEGXL_ENABLE_PLUGINS=OFF
		)
	fi

	cmake_src_configure
}

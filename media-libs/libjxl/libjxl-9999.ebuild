# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib flag-o-matic git-r3

DESCRIPTION="JPEG XL image format reference implementation"
HOMEPAGE="https://github.com/libjxl/libjxl"

EGIT_REPO_URI="https://github.com/libjxl/libjxl.git"
EGIT_SUBMODULES=(third_party/libjpeg-turbo
	third_party/skcms
	third_party/testdata
)

LICENSE="BSD"
SLOT="0"
IUSE="gdk-pixbuf openexr test"
RESTRICT="!test? ( test )"

DEPEND="app-arch/brotli:=[${MULTILIB_USEDEP}]
	>=dev-cpp/highway-1.0.7[${MULTILIB_USEDEP}]
	media-libs/giflib:=[${MULTILIB_USEDEP}]
	>=media-libs/lcms-2.13:2[${MULTILIB_USEDEP}]
	media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}]
	media-libs/libpng:=[${MULTILIB_USEDEP}]
	>=x11-misc/shared-mime-info-2.2
	gdk-pixbuf? (
		dev-libs/glib:2
		x11-libs/gdk-pixbuf:2
	)
	openexr? ( media-libs/openexr:= )
	test? ( dev-cpp/gtest )
"
RDEPEND="${DEPEND}"

multilib_src_configure() {
	filter-lto

	local mycmakeargs=(
		-DJPEGXL_ENABLE_BENCHMARK=OFF
		-DJPEGXL_ENABLE_COVERAGE=OFF
		-DJPEGXL_ENABLE_FUZZERS=OFF
		-DJPEGXL_ENABLE_SJPEG=OFF
		-DJPEGXL_WARNINGS_AS_ERRORS=OFF

		-DJPEGXL_ENABLE_SKCMS=ON
		-DJPEGXL_ENABLE_VIEWERS=OFF
		-DJPEGXL_FORCE_SYSTEM_BROTLI=ON
		-DJPEGXL_FORCE_SYSTEM_GTEST=ON
		-DJPEGXL_FORCE_SYSTEM_HWY=ON
		-DJPEGXL_FORCE_SYSTEM_LCMS2=ON
		-DJPEGXL_ENABLE_DOXYGEN=OFF
		-DJPEGXL_ENABLE_MANPAGES=OFF
		-DJPEGXL_ENABLE_JNI=OFF
		-DJPEGXL_ENABLE_JPEGLI_LIBJPEG=OFF
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
			-DBUILD_TESTING=$(usex test ON OFF)
		)
	else
		mycmakeargs+=(
			-DJPEGXL_ENABLE_TOOLS=OFF
			-DJPEGXL_ENABLE_OPENEXR=OFF
			-DJPEGXL_ENABLE_PLUGINS=OFF
			-DBUILD_TESTING=OFF
		)
	fi

	cmake_src_configure
}

multilib_src_install() {
	cmake_src_install

	find "${ED}" -name '*.a' -delete || die
}

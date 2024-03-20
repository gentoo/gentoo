# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib flag-o-matic

DESCRIPTION="JPEG XL image format reference implementation"
HOMEPAGE="https://github.com/libjxl/libjxl"
SRC_URI="https://github.com/libjxl/libjxl/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ~loong ~ppc ppc64 ~riscv ~sparc x86"
IUSE="openexr"

DEPEND="app-arch/brotli:=[${MULTILIB_USEDEP}]
	>=dev-cpp/highway-1.0.0[${MULTILIB_USEDEP}]
	media-libs/giflib:=[${MULTILIB_USEDEP}]
	>=media-libs/lcms-2.13:2[${MULTILIB_USEDEP}]
	media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}]
	media-libs/libpng:=[${MULTILIB_USEDEP}]
	>=x11-misc/shared-mime-info-2.2
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

		-DJPEGXL_ENABLE_SKCMS=OFF
		-DJPEGXL_ENABLE_VIEWERS=OFF
		-DJPEGXL_ENABLE_PLUGINS=OFF
		-DJPEGXL_FORCE_SYSTEM_BROTLI=ON
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
		)
	else
		mycmakeargs+=(
			-DJPEGXL_ENABLE_TOOLS=OFF
			-DJPEGXL_ENABLE_OPENEXR=OFF
		)
	fi

	cmake_src_configure
}

multilib_src_install() {
	cmake_src_install

	find "${ED}" -name '*.a' -delete || die
}

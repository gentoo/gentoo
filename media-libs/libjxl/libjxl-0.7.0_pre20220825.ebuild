# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="JPEG XL image format reference implementation"
HOMEPAGE="https://github.com/libjxl/libjxl"

COMMIT="4c31ef03e3fd5239d6b794771d4ae7daa7815b28"
SRC_URI="https://api.github.com/repos/libjxl/libjxl/tarball/${COMMIT} -> ${P}.tar.gz"
S="${WORKDIR}/libjxl-libjxl-${COMMIT:0:7}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="openexr"

DEPEND="app-arch/brotli:=[${MULTILIB_USEDEP}]
	dev-cpp/gflags:=[${MULTILIB_USEDEP}]
	>=dev-cpp/highway-1.0.0[${MULTILIB_USEDEP}]
	media-libs/giflib:=[${MULTILIB_USEDEP}]
	>=media-libs/lcms-2.13:=[${MULTILIB_USEDEP}]
	media-libs/libjpeg-turbo[${MULTILIB_USEDEP}]
	media-libs/libpng:=[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	>=x11-misc/shared-mime-info-2.2
	openexr? ( media-libs/openexr:= )
"
RDEPEND="${DEPEND}"

multilib_src_configure() {
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

	find "${D}" -name '*.a' -delete || die
}

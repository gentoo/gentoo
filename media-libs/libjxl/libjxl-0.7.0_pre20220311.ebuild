# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_ECLASS=cmake
inherit cmake-multilib xdg

DESCRIPTION="JPEG XL image format reference implementation"
HOMEPAGE="https://github.com/libjxl/libjxl"

SRC_URI="https://api.github.com/repos/libjxl/libjxl/tarball/3f8e77fcfabe8ca8ddee6be4e662de525667c570 -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="BSD"
SLOT="0"
IUSE="examples openexr"

DEPEND="app-arch/brotli:=[${MULTILIB_USEDEP}]
	dev-cpp/gflags:=[${MULTILIB_USEDEP}]
	>=dev-cpp/highway-0.16.0[${MULTILIB_USEDEP}]
	media-libs/giflib:=[${MULTILIB_USEDEP}]
	media-libs/lcms:=[${MULTILIB_USEDEP}]
	media-libs/libpng:=[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	virtual/jpeg[${MULTILIB_USEDEP}]
	x11-misc/shared-mime-info
	openexr? ( media-libs/openexr:= )
"

RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-0.7.0-pthread.patch" )

S="${WORKDIR}/libjxl-libjxl-3f8e77f"

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
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
	)

	if multilib_is_native_abi; then
		mycmakeargs+=(
			-DJPEGXL_ENABLE_TOOLS=ON
			-DJPEGXL_ENABLE_EXAMPLES=$(usex examples)
			-DJPEGXL_ENABLE_OPENEXR=$(usex openexr)
		)
	else
		mycmakeargs+=(
			-DJPEGXL_ENABLE_TOOLS=OFF
			-DJPEGXL_ENABLE_EXAMPLES=OFF
			-DJPEGXL_ENABLE_OPENEXR=OFF
		)
	fi

	cmake_src_configure
}

multilib_src_install() {
	cmake_src_install

	if multilib_is_native_abi; then
		if use examples; then
			dobin "${BUILD_DIR}/jxlinfo"
		fi

		insinto /usr/share/mime/packages
		doins -r "${S}"/plugins/mime/image-jxl.xml
	fi

	find "${D}" -name '*.a' -delete || die
}

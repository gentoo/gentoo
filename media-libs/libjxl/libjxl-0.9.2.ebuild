# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib flag-o-matic gnome2-utils

# This changes frequently.  Please check the testdata submodule when bumping.
TESTDATA_COMMIT="ff8d743aaba05b3014f17e5475e576242fa979fc"
DESCRIPTION="JPEG XL image format reference implementation"
HOMEPAGE="https://github.com/libjxl/libjxl/"
SRC_URI="
	https://github.com/libjxl/libjxl/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
	test? (
		https://github.com/libjxl/testdata/archive/${TESTDATA_COMMIT}.tar.gz
			-> ${PN}-testdata-${TESTDATA_COMMIT}.tar.gz
	)
"

LICENSE="BSD"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~ppc ppc64 ~riscv ~sparc x86"
IUSE="+gdk-pixbuf openexr test"
RESTRICT="!test? ( test )"

DEPEND="
	app-arch/brotli:=[${MULTILIB_USEDEP}]
	>=dev-cpp/highway-1.0.7[${MULTILIB_USEDEP}]
	media-libs/giflib:=[${MULTILIB_USEDEP}]
	>=media-libs/lcms-2.13:2[${MULTILIB_USEDEP}]
	media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}]
	media-libs/libpng:=[${MULTILIB_USEDEP}]
	gdk-pixbuf? (
		dev-libs/glib:2
		x11-libs/gdk-pixbuf:2
	)
	openexr? ( media-libs/openexr:= )
"
RDEPEND="
	${DEPEND}
	>=x11-misc/shared-mime-info-2.2
"
DEPEND+="
	test? ( dev-cpp/gtest[${MULTILIB_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}/${PN}-0.9.1-backport-pr3143.patch"
)

multilib_src_configure() {
	filter-lto

	local mycmakeargs=(
		-DJPEGXL_ENABLE_BENCHMARK=OFF
		-DJPEGXL_ENABLE_COVERAGE=OFF
		-DJPEGXL_ENABLE_FUZZERS=OFF
		-DJPEGXL_ENABLE_SJPEG=OFF
		-DJPEGXL_WARNINGS_AS_ERRORS=OFF

		-DJPEGXL_ENABLE_SKCMS=OFF
		-DJPEGXL_ENABLE_VIEWERS=OFF
		-DJPEGXL_FORCE_SYSTEM_BROTLI=ON
		-DJPEGXL_FORCE_SYSTEM_GTEST=ON
		-DJPEGXL_FORCE_SYSTEM_HWY=ON
		-DJPEGXL_FORCE_SYSTEM_LCMS2=ON
		-DJPEGXL_ENABLE_DOXYGEN=OFF
		-DJPEGXL_ENABLE_MANPAGES=OFF
		-DJPEGXL_ENABLE_JNI=OFF
		-DJPEGXL_ENABLE_JPEGLI=OFF
		-DJPEGXL_ENABLE_JPEGLI_LIBJPEG=OFF
		-DJPEGXL_ENABLE_TCMALLOC=OFF
		-DJPEGXL_ENABLE_EXAMPLES=OFF
		-DBUILD_TESTING=$(usex test ON OFF)
	)

	if use test; then
		mycmakeargs+=(
			-DJPEGXL_TEST_DATA_PATH="${WORKDIR}/testdata-${TESTDATA_COMMIT}"
		)
	fi

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

multilib_src_install() {
	cmake_src_install

	find "${ED}" -name '*.a' -delete || die
}

pkg_postinst() {
	use gdk-pixbuf && multilib_foreach_abi gnome2_gdk_pixbuf_update
}

pkg_postrm() {
	use gdk-pixbuf && multilib_foreach_abi gnome2_gdk_pixbuf_update
}

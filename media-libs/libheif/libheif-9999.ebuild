# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib gnome2-utils xdg

DESCRIPTION="ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
HOMEPAGE="https://github.com/strukturag/libheif"

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/strukturag/libheif.git"
	inherit git-r3
else
	SRC_URI="https://github.com/strukturag/libheif/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
fi

LICENSE="GPL-3 MIT"
SLOT="0/$(ver_cut 1-2)"
IUSE="+aom dav1d +de265 doc examples ffmpeg gdk-pixbuf +jpeg +jpeg2k +kvazaar openh264 rav1e svt-av1 test test-full +threads tools +webp x265"
# IUSE+=" vvdec vvenc"
REQUIRED_USE="test-full? ( test )"
RESTRICT="!test? ( test )"

BDEPEND="
	doc? ( app-text/doxygen )
"
DEPEND="
	media-libs/libpng:=[${MULTILIB_USEDEP}]
	media-libs/tiff:=[${MULTILIB_USEDEP}]
	sys-libs/zlib:=[${MULTILIB_USEDEP}]
	aom? ( >=media-libs/libaom-2.0.0:=[${MULTILIB_USEDEP}] )
	dav1d? ( media-libs/dav1d:=[${MULTILIB_USEDEP}] )
	de265? ( media-libs/libde265[${MULTILIB_USEDEP}] )
	ffmpeg? ( media-video/ffmpeg:=[${MULTILIB_USEDEP}] )
	gdk-pixbuf? ( x11-libs/gdk-pixbuf[${MULTILIB_USEDEP}] )
	jpeg? ( media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}] )
	jpeg2k? ( media-libs/openjpeg:=[${MULTILIB_USEDEP}] )
	openh264? ( media-libs/openh264:=[${MULTILIB_USEDEP}] )
	rav1e? ( media-video/rav1e:= )
	svt-av1? ( media-libs/svt-av1:=[${MULTILIB_USEDEP}] )
	tools? (
		examples? (
			media-libs/libsdl2:=[${MULTILIB_USEDEP}]
		)
	)
	webp? ( media-libs/libwebp:= )
	x265? ( media-libs/x265:=[${MULTILIB_USEDEP}] )
"
# 	vvdec? ( >=media-libs/vvdec-2.3.0:=::guru[${MULTILIB_USEDEP}] )
# 	vvenc? ( media-libs/vvenc:=::guru[${MULTILIB_USEDEP}] )
RDEPEND="${DEPEND}"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/libheif/heif_version.h
)

multilib_src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package doc Doxygen)
		-DBUILD_TESTING=$(usex test)
		-DENABLE_PLUGIN_LOADING=true
		-DWITH_LIBDE265=$(usex de265)
		-DWITH_AOM_DECODER=$(usex aom)
		-DWITH_AOM_ENCODER=$(usex aom)
		-DWITH_DAV1D=$(usex dav1d)
		-DWITH_EXAMPLES=$(usex examples)
		-DWITH_EXAMPLE_HEIF_VIEW=$(usex examples $(usex tools))
		-DWITH_FFMPEG_DECODER=$(usex ffmpeg)
		-DWITH_GDK_PIXBUF=$(usex gdk-pixbuf)
		-DWITH_OpenH264_DECODER=$(usex openh264)
		-DWITH_OpenH264_ENCODER=$(usex openh264)
		-DWITH_RAV1E=$(multilib_native_usex rav1e)
		-DWITH_SvtEnc=$(usex svt-av1)
		-DWITH_LIBSHARPYUV=$(usex webp)
		# -DWITH_VVDEC=$(usex vvdec) # vvdec not yet packaged, in ::guru
		# -DWITH_VVENC=$(usex vvenc) # vvenc not yet packaged, in ::guru
		-DWITH_X265=$(usex x265)
		-DWITH_KVAZAAR=$(usex kvazaar)
		-DWITH_JPEG_DECODER=$(usex jpeg)
		-DWITH_JPEG_ENCODER=$(usex jpeg)
		-DWITH_OpenJPEG_DECODER=$(usex jpeg2k)
		-DWITH_OpenJPEG_ENCODER=$(usex jpeg2k)
	)

	# Allow tests that rely on options not normally enabled
	# https://github.com/strukturag/libheif/blob/v1.20.1/tests/CMakeLists.txt#L36-L46
	# https://github.com/strukturag/libheif/blob/v1.20.1/tests/CMakeLists.txt#L82-L101
	if use test && use test-full; then
		mycmakeargs+=(
			-DENABLE_EXPERIMENTAL_FEATURES=ON
			-DWITH_REDUCED_VISIBILITY=OFF
			-DWITH_UNCOMPRESSED_CODEC=ON
		)
	fi

	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	use gdk-pixbuf && multilib_foreach_abi gnome2_gdk_pixbuf_update
}

pkg_postrm() {
	xdg_pkg_postrm
	use gdk-pixbuf && multilib_foreach_abi gnome2_gdk_pixbuf_update
}

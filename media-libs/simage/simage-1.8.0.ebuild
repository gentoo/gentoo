# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic

DESCRIPTION="Image and video texturing library"
HOMEPAGE="https://github.com/coin3d/simage/"
SRC_URI="https://github.com/coin3d/simage/archive/${P}.tar.gz"

LICENSE="BSD-1"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"
IUSE="debug gif jpeg png qt5 sndfile test tiff vorbis"
RESTRICT="!test? ( test )"

RDEPEND="
	sys-libs/zlib:=
	gif? ( media-libs/giflib:= )
	jpeg? ( virtual/jpeg:0 )
	png? ( media-libs/libpng:0= )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
	)
	sndfile? ( media-libs/libsndfile )
	tiff? ( media-libs/tiff:0 )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
"
DEPEND="
	${RDEPEND}
	test? ( media-libs/libsndfile )
"

S="${WORKDIR}/${PN}-${P}"

PATCHES=(
	"${FILESDIR}/${PN}-1.7.1-cmake-automagic-deps.patch"
	# examples need to link against libsndfile unconditionally so either we could
	# make the dep unconditional or not build the examples. i chose the latter way.
	# btw, examples are not installed anyway, they are just compiled.
	"${FILESDIR}/${PN}-1.7.1-disable-examples.patch"
	"${FILESDIR}/${PN}-1.7.1-tests-conditional.patch"
	"${FILESDIR}/${PN}-1.7.1-disable-gif-quantize-buffer.patch"
	"${FILESDIR}/${P}-0001-CMakeLists.txt-comment-cpack.d-inclusion.patch"
)

DOCS=(AUTHORS ChangeLog NEWS README)

src_configure() {
	use debug && append-cppflags -DSIMAGE_DEBUG=1

	local mycmakeargs=(
		-DSIMAGE_AVIENC_SUPPORT=OFF # Windows only
		-DSIMAGE_BUILD_SHARED_LIBS=ON
		-DSIMAGE_CGIMAGE_SUPPORT=OFF # OS X only
		-DSIMAGE_EPS_SUPPORT=ON
		-DSIMAGE_GDIPLUS_SUPPORT=OFF # Windows only
		-DSIMAGE_GIF_SUPPORT=$(usex gif)
		-DSIMAGE_JASPER_SUPPORT=OFF
		-DSIMAGE_JPEG_SUPPORT=$(usex jpeg)
		-DSIMAGE_LIBSNDFILE_SUPPORT=$(usex sndfile)
		-DSIMAGE_MPEG2ENC_SUPPORT=ON
		-DSIMAGE_OGGVORBIS_SUPPORT=$(usex vorbis)
		-DSIMAGE_PIC_SUPPORT=ON
		-DSIMAGE_PNG_SUPPORT=$(usex png)
		-DSIMAGE_QIMAGE_SUPPORT=$(usex qt5)
		-DSIMAGE_QUICKTIME_SUPPORT=OFF # OS X only
		-DSIMAGE_TIFF_SUPPORT=$(usex tiff)
		-DSIMAGE_USE_QT5=ON
		-DSIMAGE_RGB_SUPPORT=ON
		-DSIMAGE_TGA_SUPPORT=ON
		-DSIMAGE_XWD_SUPPORT=ON
		-DTESTS=$(usex test)
	)

	cmake_src_configure
}

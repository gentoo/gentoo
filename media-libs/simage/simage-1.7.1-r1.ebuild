# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils flag-o-matic

DESCRIPTION="Image and video texturing library"
HOMEPAGE="https://bitbucket.org/Coin3D/simage"
SRC_URI="https://bitbucket.org/Coin3D/simage/downloads/${P}-src.zip"

LICENSE="public-domain mpeg2enc"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"
IUSE="debug gif jpeg png qt5 sndfile tiff vorbis"

RDEPEND="
	gif? ( media-libs/giflib )
	jpeg? ( virtual/jpeg:0= )
	png? ( media-libs/libpng:0= )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
	)
	sndfile? ( media-libs/libsndfile )
	tiff? ( media-libs/tiff:0= )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
"
DEPEND="
	${RDEPEND}
	app-arch/unzip
"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}/${P}-cmake-automagic-deps.patch"
	"${FILESDIR}/${P}-fix-examples-linking.patch"
	"${FILESDIR}/${P}-disable-gif-quantize-buffer.patch"
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
	)

	cmake-utils_src_configure
}

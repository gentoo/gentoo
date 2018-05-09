# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils flag-o-matic

MY_P=Coin3D-simage-3bd369da8f08

DESCRIPTION="Image and video texturing library"
HOMEPAGE="https://bitbucket.org/Coin3D/simage"
SRC_URI="https://dev.gentoo.org/~reavertm/${MY_P}.tar.bz2"

LICENSE="public-domain mpeg2enc"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~x86"
SLOT="0"
IUSE="debug gif jpeg jpeg2k png qt5 sndfile tiff vorbis"

RDEPEND="
	gif? ( media-libs/giflib )
	jpeg? ( virtual/jpeg:0= )
	jpeg2k? ( media-libs/jasper )
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
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${PN}-1.7.1-cmake-automagic-deps.patch"
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
		-DSIMAGE_JASPER_SUPPORT=$(usex jpeg2k)
		-DSIMAGE_JPEG_SUPPORT=$(usex jpeg)
		-DSIMAGE_LIBSNDFILE_SUPPORT=$(usex sndfile)
		-DSIMAGE_MPEG2ENC_SUPPORT=ON
		-DSIMAGE_OGGVORBIS_SUPPORT=$(usex vorbis)
		-DSIMAGE_PIC_SUPPORT=ON
		-DSIMAGE_PNG_SUPPORT=$(usex png)
		-DSIMAGE_QIMAGE_SUPPORT=$(usex qt5)
		-DSIMAGE_QUICKTIME_SUPPORT=OFF # OS X only
		-DSIMAGE_TIFF_SUPPORT=$(usex tiff)
		-DUSE_QT5=ON
		-DSIMAGE_RGB_SUPPORT=ON
		-DSIMAGE_TGA_SUPPORT=ON
		-DSIMAGE_XWD_SUPPORT=ON
	)

	cmake-utils_src_configure
}

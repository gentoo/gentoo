# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic

DESCRIPTION="Image and video texturing library"
HOMEPAGE="https://github.com/coin3d/simage/"

if [[ ${PV} = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/coin3d/simage.git"
else
	SRC_URI="https://github.com/coin3d/simage/releases/download/v${PV}/${P}-src.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
	S="${WORKDIR}/${PN}"
fi

LICENSE="BSD-1"
SLOT="0"
IUSE="gif jpeg png qt5 sndfile test tiff vorbis zlib"
RESTRICT="!test? ( test )"

RDEPEND="
	gif? ( media-libs/giflib:= )
	jpeg? ( virtual/jpeg:0 )
	png? ( media-libs/libpng:0= )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
	)
	sndfile? (
		media-libs/libsndfile
		media-libs/flac
	)
	tiff? (
		media-libs/tiff[lzma,zstd]
		app-arch/xz-utils
		app-arch/zstd:=
	)
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
		media-libs/opus
	)
	zlib? ( sys-libs/zlib:= )
"
DEPEND="${RDEPEND}"
BDEPEND="test? ( media-libs/libsndfile )"

PATCHES=(
	"${FILESDIR}"/${P}-0001-Gentoo-specific-remove-RELEASE-flag-from-pkg-config.patch
)

DOCS=(AUTHORS ChangeLog NEWS README)

src_configure() {
	local mycmakeargs=(
		-DSIMAGE_BUILD_DOCUMENTATION=OFF
		-DSIMAGE_BUILD_EXAMPLES=OFF
		-DSIMAGE_BUILD_SHARED_LIBS=ON
		-DSIMAGE_BUILD_TESTS=$(usex test)
		-DSIMAGE_EPS_SUPPORT=ON
		-DSIMAGE_GIF_SUPPORT=$(usex gif)
		-DSIMAGE_JPEG_SUPPORT=$(usex jpeg)
		-DSIMAGE_LIBSNDFILE_SUPPORT=$(usex sndfile)
		-DSIMAGE_MPEG2ENC_SUPPORT=ON
		-DSIMAGE_OGGVORBIS_SUPPORT=$(usex vorbis)
		-DSIMAGE_PIC_SUPPORT=ON
		-DSIMAGE_PNG_SUPPORT=$(usex png)
		-DSIMAGE_RGB_SUPPORT=ON
		-DSIMAGE_TGA_SUPPORT=ON
		-DSIMAGE_TIFF_SUPPORT=$(usex tiff)
		-DSIMAGE_USE_AVIENC=OFF # Windows only
		-DSIMAGE_USE_CGIMAGE=OFF # OS X only
		-DSIMAGE_USE_GDIPLUS=OFF # Windows only
		-DSIMAGE_USE_QIMAGE=$(usex qt5)
		-DSIMAGE_USE_QT5=$(usex qt5)
		-DSIMAGE_USE_QUICKTIME=OFF # OS X only
		-DSIMAGE_XWD_SUPPORT=ON
		-DSIMAGE_ZLIB_SUPPORT=$(usex zlib)
	)

	cmake_src_configure
}

# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Image and video texturing library"
HOMEPAGE="https://github.com/coin3d/simage https://github.com/coin3d/coin/wiki"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/coin3d/${PN,,}.git"
else
	SRC_URI="https://github.com/coin3d/${PN,,}/releases/download/v${PV}/${P/${PN}/${PN,,}}-src.tar.gz"
	S="${WORKDIR}/${PN,,}"

	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

LICENSE="BSD-1"
# SONAME
SLOT="0/20"
IUSE="gif jpeg png qt6 sndfile test tiff vorbis zlib"
RESTRICT="!test? ( test )"

RDEPEND="
	gif? ( media-libs/giflib:= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	png? ( media-libs/libpng:= )
	qt6? ( dev-qt/qtbase:6[gui] )
	sndfile? (
		media-libs/libsndfile
		media-libs/flac:=
	)
	tiff? (
		media-libs/tiff:=[lzma,zstd]
		app-arch/xz-utils
		app-arch/zstd:=
	)
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
		media-libs/opus
	)
	zlib? ( virtual/zlib:= )
"
DEPEND="${RDEPEND}"
BDEPEND="test? ( media-libs/libsndfile )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.8.1-0001-Gentoo-specific-remove-RELEASE-flag-from-pkg-config.patch
)

DOCS=( AUTHORS ChangeLog NEWS README )

src_configure() {
	local mycmakeargs=(
		-D${PN^^}_BUILD_SHARED_LIBS=ON
		-D${PN^^}_BUILD_EXAMPLES=OFF
		-D${PN^^}_BUILD_TESTS=$(usex test)
		-D${PN^^}_BUILD_DOCUMENTATION=OFF
		-D${PN^^}_USE_AVIENC=OFF # Windows only
		-D${PN^^}_USE_GDIPLUS=OFF # Windows
		-D${PN^^}_USE_CGIMAGE=OFF # OS X only
		-D${PN^^}_USE_QUICKTIME=OFF # OS X only
		-D${PN^^}_USE_QIMAGE=$(usex qt6)
		-D${PN^^}_USE_QT5=OFF
		-D${PN^^}_USE_QT6=$(usex qt6)
		-D${PN^^}_USE_CPACK=OFF
		-D${PN^^}_USE_STATIC_LIBS=OFF
		-D${PN^^}_LIBJASPER_SUPPORT=OFF
		-D${PN^^}_LIBSNDFILE_SUPPORT=$(usex sndfile)
		-D${PN^^}_OGGVORBIS_SUPPORT=$(usex vorbis)
		-D${PN^^}_EPS_SUPPORT=ON
		-D${PN^^}_MPEG2ENC_SUPPORT=ON
		-D${PN^^}_PIC_SUPPORT=ON
		-D${PN^^}_RGB_SUPPORT=ON
		-D${PN^^}_TGA_SUPPORT=ON
		-D${PN^^}_XWD_SUPPORT=ON
		-D${PN^^}_ZLIB_SUPPORT=$(usex zlib)
		-D${PN^^}_GIF_SUPPORT=$(usex gif)
		-D${PN^^}_JPEG_SUPPORT=$(usex jpeg)
		-D${PN^^}_PNG_SUPPORT=$(usex png)
		-D${PN^^}_TIFF_SUPPORT=$(usex tiff)
	)
	cmake_src_configure
}

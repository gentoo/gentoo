# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Image and video texturing library"
HOMEPAGE="https://bitbucket.org/Coin3D/simage"
SRC_URI="https://bitbucket.org/Coin3D/coin/downloads/${P}.tar.gz"

LICENSE="public-domain mpeg2enc"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
SLOT="0"
IUSE="debug gif jpeg jpeg2k png sndfile static-libs tiff vorbis zlib"
RESTRICT="mirror bindist" #465086

RDEPEND="
	gif? ( media-libs/giflib )
	jpeg? ( virtual/jpeg:0= )
	jpeg2k? ( media-libs/jasper )
	png? ( media-libs/libpng:0= )
	sndfile? ( media-libs/libsndfile )
	tiff? ( media-libs/tiff:0= )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

DOCS=(AUTHORS ChangeLog NEWS README)

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.0-pkgconfig-partial.patch
	"${FILESDIR}"/${PN}-1.7.0-libpng15.patch
)

# --with-pic, two defined (PIC and one for image format, sillyt), no not pass
# --enable-qimage, broken Qt checks, unable to locate FHS-compliant Qt install
# --with-x, not used anywhere
src_configure() {
	econf \
		--disable-qimage \
		--disable-quicktime \
		--with-eps \
		--with-mpeg2enc \
		--with-rgb \
		--with-targa \
		--with-xwd \
		--without-x \
		$(use_with gif) \
		$(use_enable debug) \
		$(use_enable debug symbols) \
		$(use_with jpeg) \
		$(use_with jpeg2k jasper) \
		$(use_with png) \
		$(use_with sndfile libsndfile) \
		$(use_enable static-libs static) \
		$(use_with tiff) \
		$(use_with vorbis oggvorbis) \
		$(use_with zlib)
}

src_install() {
	# Remove simage from Libs.private
	sed -e '/Libs.private/s/ -lsimage//' -i simage.pc || die

	default

	# Remove libtool files when not needed.
	if use static-libs; then
		rm -f "${ED}"/usr/lib*/*.la || die
	fi
}

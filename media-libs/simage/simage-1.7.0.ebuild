# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/simage/simage-1.7.0.ebuild,v 1.9 2013/04/20 09:27:38 ulm Exp $

EAPI=2

inherit base

DESCRIPTION="Image and video texturing library"
HOMEPAGE="http://www.coin3d.org/lib/simage/"
SRC_URI="https://bitbucket.org/Coin3D/coin/downloads/${P}.tar.gz"

LICENSE="public-domain mpeg2enc"
KEYWORDS="amd64 ppc x86"
SLOT="0"
IUSE="debug gif jpeg jpeg2k png sndfile static-libs tiff vorbis zlib"
RESTRICT="mirror bindist" #465086

RDEPEND="
	gif? ( media-libs/giflib )
	jpeg? ( virtual/jpeg )
	jpeg2k? ( media-libs/jasper )
	png? ( media-libs/libpng:0 )
	sndfile? ( media-libs/libsndfile )
	tiff? ( media-libs/tiff:0 )
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

	base_src_install

	# Remove libtool files when not needed.
	use static-libs || rm -f "${D}"/usr/lib*/*.la
}

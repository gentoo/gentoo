# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/oxine/oxine-0.7.1-r1.ebuild,v 1.4 2014/03/09 22:01:57 phajdan.jr Exp $

EAPI="5"
WANT_AUTOMAKE="1.9"
inherit eutils

DESCRIPTION="OSD frontend for Xine"
HOMEPAGE="http://oxine.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc ~ppc64 x86"
SLOT="0"
IUSE="X curl debug dvb exif joystick jpeg lirc nls png v4l"

COMMON_DEPEND="media-libs/xine-lib[v4l?,X,imagemagick]
	dvb? ( media-libs/xine-lib[v4l] )
	dev-libs/libcdio
	curl? ( net-misc/curl )
	joystick? ( media-libs/libjsw )
	jpeg? ( media-gfx/imagemagick
		media-libs/netpbm[jpeg,zlib]
		media-video/mjpegtools )
	lirc? ( app-misc/lirc )
	nls? ( virtual/libintl
		sys-devel/gettext )
	png? ( media-gfx/imagemagick
		media-libs/netpbm[png,zlib]
		media-video/mjpegtools )
	X? ( x11-libs/libXext
		x11-libs/libX11 )"
RDEPEND="${COMMON_DEPEND}
	virtual/eject"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"

src_configure() {
	# Note on images: Image support will be automatically disabled if
	# netpbm, imagemagick or mjpegtools is not installed, irregardless
	# of what the USE flags are set to.

	# If one of the image USE flags is unset, disable image support
	if use !png && use !jpeg ; then
		myconf="${myconf} --disable-images"
	fi

	econf ${myconf} \
		$( use_with X x ) \
		$( use_with curl ) \
		$( use_enable debug ) \
		$( use_enable dvb ) \
		$( use_enable exif ) \
		--disable-hal \
		$( use_enable joystick ) \
		$( use_enable lirc ) \
		$( use_enable nls ) \
		$( use_enable v4l ) \
		--disable-extractor \
		--disable-rpath || die "econf died"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install died"
	dodoc AUTHORS ChangeLog NEWS README TODO
	dohtml doc/README.html doc/keymapping.pdf
}

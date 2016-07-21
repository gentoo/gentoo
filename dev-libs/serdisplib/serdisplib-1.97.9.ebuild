# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils

DESCRIPTION="Library to drive serial/parallel/usb displays with built-in controllers"
HOMEPAGE="http://serdisplib.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="sdl usb"

DEPEND="media-libs/gd[jpeg,png]
	sdl? ( media-libs/libsdl )
	usb? ( virtual/libusb:0 )"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		--prefix="${D}/usr" \
		$(use_enable sdl libSDL) \
		$(use_enable usb libusb)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS HISTORY README BUGS PINOUTS
}

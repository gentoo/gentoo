# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/usbredir/usbredir-0.4.3.ebuild,v 1.6 2012/06/20 08:14:19 jdhore Exp $

EAPI=4

DESCRIPTION="A simple TCP daemon and set of libraries for the usbredir protocol (redirecting USB traffic)"
HOMEPAGE="http://spice-space.org/page/UsbRedir"
SRC_URI="http://spice-space.org/download/${PN}/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

RDEPEND="virtual/libusb:1"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="ChangeLog README* TODO *.txt"

src_prepare() {
	sed -i -e 's:-Werror::' configure || die
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	rm -f "${ED}"/usr/lib*/lib*.la
}

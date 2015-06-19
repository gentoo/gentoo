# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libmodbus/libmodbus-3.0.6.ebuild,v 1.2 2014/07/10 15:59:24 xmw Exp $

EAPI=4

DESCRIPTION="Modbus library which supports RTU communication over a serial line or a TCP link"
HOMEPAGE="http://libmodbus.org/"
SRC_URI="http://libmodbus.org/releases/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

src_configure() {
	econf \
		--disable-silent-rules \
		$(use_enable static-libs static)
}

src_install() {
	emake install DESTDIR="${D}"
	dodoc AUTHORS MIGRATION NEWS README.rst
	use static-libs || rm "${D}"/usr/*/libmodbus.la
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/fakechroot/fakechroot-2.17.2.ebuild,v 1.3 2015/04/21 17:48:41 pacho Exp $

EAPI=5
inherit eutils

DESCRIPTION="Provide a faked chroot environment without requiring root privileges"
HOMEPAGE="http://fakechroot.alioth.debian.org/"
SRC_URI="mirror://debian/pool/main/f/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RESTRICT="test"

src_configure() {
	econf --disable-static
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc NEWS.md README.md THANKS
	find "${D}" -name '*.la' -exec rm -f '{}' +
}

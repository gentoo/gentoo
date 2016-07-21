# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils

DESCRIPTION="a small stealth network autoconfigure software"
HOMEPAGE="http://selfdhcp.sourceforge.net"
SRC_URI="mirror://sourceforge/selfdhcp/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~sparc ~x86"
IUSE=""

DEPEND="dev-libs/popt
	dev-libs/libxml2
	>=net-libs/libnet-1.0.2
	net-libs/libpcap"

src_prepare() {
	epatch "${FILESDIR}/${P}-buffer-overflow.patch"
}

src_configure() {
	econf --sysconfdir=/etc --sbindir=/sbin
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog README TODO
}

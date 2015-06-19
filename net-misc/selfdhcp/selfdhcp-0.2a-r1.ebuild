# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/selfdhcp/selfdhcp-0.2a-r1.ebuild,v 1.3 2014/08/30 12:37:22 mgorny Exp $

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

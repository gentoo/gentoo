# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/pcapfix/pcapfix-0.7.ebuild,v 1.3 2013/11/06 03:11:15 patrick Exp $

EAPI=4

DESCRIPTION="Repair and fix broken pcap files"
HOMEPAGE="http://f00l.de/pcapfix/"
SRC_URI="http://f00l.de/pcapfix/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	sed -e 's/gcc/$(CC) $(CFLAGS)/g' -i Makefile
}

src_install() {
	doman pcapfix.1
	dobin pcapfix
	dodoc README TODO Changelog
}

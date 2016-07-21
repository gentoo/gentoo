# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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

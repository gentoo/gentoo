# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

DESCRIPTION="A network monitoring tool with bandwidth tracking"
HOMEPAGE="http://www.adaptive-enterprises.com.au/~d/software/pktstat/"
SRC_URI="http://www.adaptive-enterprises.com.au/~d/software/pktstat/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="
	net-libs/libpcap
	>=sys-libs/ncurses-5.3-r1
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-tinfo.patch
	epatch "${FILESDIR}"/${P}-smtp_line.patch
	eautoreconf
}

src_install() {
	dosbin pktstat
	doman pktstat.1
	dodoc ChangeLog NEWS README TODO
}

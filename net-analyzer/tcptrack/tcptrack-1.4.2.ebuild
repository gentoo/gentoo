# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/tcptrack/tcptrack-1.4.2.ebuild,v 1.3 2014/07/17 20:11:22 jer Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="Passive per-connection tcp bandwidth monitor"
HOMEPAGE="http://www.rhythm.cx/~steve/devel/tcptrack/"
SRC_URI="http://www.rhythm.cx/~steve/devel/tcptrack/release/${PV}/source/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

DEPEND="
	net-libs/libpcap
	sys-libs/ncurses
"
RDEPEND="
	${DEPEND}
	virtual/pkgconfig
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-tinfo.patch
	sed -i src/Makefile.am -e 's| -Werror||g' || die
	eautoreconf
}

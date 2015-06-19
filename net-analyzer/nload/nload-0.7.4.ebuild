# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nload/nload-0.7.4.ebuild,v 1.9 2014/07/15 00:01:32 jer Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="console application which monitors network traffic and bandwidth usage in real time"
HOMEPAGE="http://www.roland-riegel.de/nload/index.html"
SRC_URI="http://www.roland-riegel.de/nload/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~mips ppc x86"

RDEPEND=">=sys-libs/ncurses-5.2"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
src_prepare() {
	epatch "${FILESDIR}"/${P}-tinfo.patch
	eautoreconf
}

src_configure() {
	# --enable-debug means do not strip debugging symbols (default no)
	econf --enable-debug
}

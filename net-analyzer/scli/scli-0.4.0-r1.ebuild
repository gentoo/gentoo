# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/scli/scli-0.4.0-r1.ebuild,v 1.6 2014/11/06 01:08:43 jer Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="SNMP Command Line Interface"
HOMEPAGE="http://cnds.eecs.jacobs-university.de/users/schoenw/articles/software/index.html"
SRC_URI="ftp://ftp.ibr.cs.tu-bs.de/pub/local/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libxml2
	net-libs/gnet
	net-libs/gsnmp
	sys-libs/ncurses
	sys-libs/readline
	sys-libs/zlib
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

DOCS=( AUTHORS ChangeLog NEWS PORTING README TODO )

src_prepare() {
	epatch "${FILESDIR}"/${P}-configure.patch

	eautoreconf
}

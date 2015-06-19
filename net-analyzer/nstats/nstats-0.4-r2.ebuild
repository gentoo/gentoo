# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nstats/nstats-0.4-r2.ebuild,v 1.5 2014/07/15 00:14:28 jer Exp $

EAPI=5

inherit autotools eutils

DESCRIPTION="Displays statistics about ethernet traffic including protocol breakdown"
SRC_URI="http://trash.net/~reeler/nstats/files/${P}.tar.gz"
HOMEPAGE="http://trash.net/~reeler/nstats/"
LICENSE="Artistic"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="
	net-libs/libpcap
	sys-libs/ncurses
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

DOCS=( BUGS doc/TODO doc/ChangeLog )

src_prepare(){
	epatch \
		"${FILESDIR}"/${P}-glibc24.patch \
		"${FILESDIR}"/${P}-makefile.patch \
		"${FILESDIR}"/${P}-tinfo.patch

	eautoreconf
}

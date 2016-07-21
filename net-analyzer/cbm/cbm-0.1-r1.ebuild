# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

DESCRIPTION="Display the current traffic on all network devices"
HOMEPAGE="http://www.isotton.com/software/unix/cbm/"
SRC_URI="http://www.isotton.com/software/unix/${PN}/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	sys-libs/ncurses
"
DEPEND="
	${RDEPEND}
	app-text/xmlto
	app-text/docbook-xml-dtd:4.4
	virtual/pkgconfig
"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gcc-4.3.patch \
		"${FILESDIR}"/${P}-gcc-4.7.patch \
		"${FILESDIR}"/${P}-tinfo.patch \
		"${FILESDIR}"/${P}-headers-status-line.patch
	eautoreconf
}

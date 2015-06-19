# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/packETH/packETH-1.8.ebuild,v 1.1 2015/01/06 20:21:05 jer Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="Packet generator tool for ethernet"
HOMEPAGE="http://packeth.sourceforge.net/"
SRC_URI="mirror://sourceforge/packeth/${P}.tar.bz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
"
DEPEND="
	virtual/pkgconfig
	${RDEPEND}
"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.7.3-libs-and-flags.patch
	eautoreconf
}

DOCS=( AUTHORS CHANGELOG README )

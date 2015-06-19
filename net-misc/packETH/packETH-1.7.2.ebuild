# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/packETH/packETH-1.7.2.ebuild,v 1.3 2012/11/20 20:37:35 ago Exp $

EAPI=4
inherit autotools

DESCRIPTION="Packet generator tool for ethernet"
HOMEPAGE="http://packeth.sourceforge.net/"
SRC_URI="mirror://sourceforge/packeth/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
"
DEPEND="
	virtual/pkgconfig
	${RDEPEND}
"
DOCS=( AUTHORS README )

src_prepare() {
	sed -i Makefile.am -e '/^  -g/d;/^  -O2/d' || die
	eautomake
}

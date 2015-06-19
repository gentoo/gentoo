# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/smet2html/smet2html-0.1.ebuild,v 1.7 2008/04/13 21:44:54 betelgeuse Exp $

DESCRIPTION="Convert eDonkey2000 server.met to html"
HOMEPAGE="http://ed2k-tools.sourceforge.net/${PN}.shtml"
SRC_URI="mirror://sourceforge/ed2k-tools/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE=""

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd ${S}

	sed -i -e "s:gcc -Wall:gcc ${CFLAGS} -Wall:g" ${S}/Makefile
}

src_compile() {
	make || die "make failed"
}

src_install() {
	dobin smet2html
}

# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/gnut/gnut-0.4.28-r1.ebuild,v 1.9 2008/04/13 21:44:17 betelgeuse Exp $

inherit eutils

DESCRIPTION="Text-mode gnutella client"
SRC_URI="http://alge.anart.no/ftp/pub/gnutella/${P}.tar.gz
	mirror://gentoo/${P}-patches.tar.bz2"
HOMEPAGE="http://www.gnutelliums.com/linux_unix/gnut/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc"
IUSE=""

src_unpack() {
	unpack ${A}
	epatch configure.patch
	epatch src.patch
}

src_install () {
	make DESTDIR="${D}" install || die
	dohtml doc/*.html
	dodoc 	doc/TUTORIAL AUTHORS COPYING ChangeLog GDJ HACKING \
		INSTALL NEWS README TODO
}

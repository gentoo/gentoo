# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/ap-utils/ap-utils-1.4.ebuild,v 1.6 2007/07/02 15:17:37 peper Exp $

inherit eutils

IUSE="nls"

DESCRIPTION="Wireless Access Point Utilities for Unix"
HOMEPAGE="http://ap-utils.polesye.net/"
SRC_URI="mirror://sourceforge/ap-utils/${P}.tar.bz2"
RESTRICT="mirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
DEPEND=">=sys-devel/bison-1.34"
RDEPEND=""

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${P}-ppc-fix.diff
}

src_compile() {
	econf --build=${CHOST} `use_enable nls` || die
	emake || die
}

src_install () {
	einstall || die
	dodoc ChangeLog NEWS README THANKS TODO
}

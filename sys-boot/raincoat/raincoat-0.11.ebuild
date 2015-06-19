# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/raincoat/raincoat-0.11.ebuild,v 1.2 2012/12/16 13:51:04 ago Exp $

inherit eutils

DESCRIPTION="Flash the Xbox boot chip"
HOMEPAGE="http://www.xbox-linux.org/"
SRC_URI="mirror://sourceforge/xbox-linux/${P}.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-build.patch
}

src_install() {
	dodir /etc /usr/bin
	emake install DESTDIR="${D}" || die
	dodoc docs/README
}

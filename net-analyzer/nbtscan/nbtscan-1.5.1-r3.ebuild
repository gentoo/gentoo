# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nbtscan/nbtscan-1.5.1-r3.ebuild,v 1.5 2014/08/27 12:29:40 ago Exp $

EAPI=5

inherit eutils

DESCRIPTION="NBTscan is a program for scanning IP networks for NetBIOS name information"
HOMEPAGE="http://www.inetcat.net/software/nbtscan.html"
SRC_URI="http://www.sourcefiles.org/Networking/Tools/Miscellanenous/${P}.tar.gz"
SRC_URI="http://www.inetcat.net/software/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"

S=${WORKDIR}/${P}a

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-includes-declarations.patch \
		"${FILESDIR}"/${P}-gentoo.patch \
		"${FILESDIR}"/${P}-script-whitespace.patch
}

src_install () {
	dobin ${PN}
	dodoc ChangeLog README
}

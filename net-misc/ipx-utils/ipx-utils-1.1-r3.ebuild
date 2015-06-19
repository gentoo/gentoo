# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ipx-utils/ipx-utils-1.1-r3.ebuild,v 1.7 2013/02/05 18:17:09 ulm Exp $

EAPI="4"
inherit eutils

DESCRIPTION="The IPX Utilities"
HOMEPAGE="ftp://sunsite.unc.edu/pub/Linux/system/filesystems/ncpfs/"
SRC_URI="ftp://sunsite.unc.edu/pub/Linux/system/filesystems/ncpfs/${P/-utils}.tar.gz"

LICENSE="ipx-utils GPL-2" # GPL-2 only for init script
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
IUSE=""

DEPEND=""

S=${WORKDIR}/${P/-utils}

src_prepare() {
	sed -i "s:-O2 -Wall:${CFLAGS}:" "${S}"/Makefile
	epatch "${FILESDIR}"/${P}-makefile.patch
	epatch "${FILESDIR}"/${P}-proc.patch #67642
}

src_install() {
	dodir /sbin /usr/share/man/man8
	dodoc "${S}"/README
	emake DESTDIR="${D}" install

	newconfd "${FILESDIR}"/ipx.confd ipx
	newinitd "${FILESDIR}"/ipx.init ipx
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
inherit eutils

DESCRIPTION="The IPX Utilities"
HOMEPAGE="ftp://sunsite.unc.edu/pub/Linux/system/filesystems/ncpfs/"
SRC_URI="ftp://sunsite.unc.edu/pub/Linux/system/filesystems/ncpfs/${P/-utils}.tar.gz"

LICENSE="ipx-utils GPL-2" # GPL-2 only for init script
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
IUSE=""

RDEPEND="!!net-fs/ncpfs" # conflicts on manpages

S=${WORKDIR}/${P/-utils}

src_prepare() {
	sed -i "s:-O2 -Wall:${CFLAGS}:" "${S}"/Makefile
	eapply "${FILESDIR}"/${P}-makefile.patch
	eapply "${FILESDIR}"/${P}-proc.patch #67642
	eapply "${FILESDIR}"/${P}-gcc-warnings.patch

	default
}

src_install() {
	doman *.8
	newconfd "${FILESDIR}"/ipx.confd ipx
	newinitd "${FILESDIR}"/ipx.init ipx

	into /sbin
	default
}

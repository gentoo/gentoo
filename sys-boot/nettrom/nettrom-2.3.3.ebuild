# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/nettrom/nettrom-2.3.3.ebuild,v 1.11 2013/04/28 21:15:01 ulm Exp $

DESCRIPTION="NetWinder ARM bootloader and utilities"
HOMEPAGE="http://www.netwinder.org/"
SRC_URI="http://wh0rd.org/gentoo/${P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* arm"
IUSE=""
RESTRICT="mirror bindist"

S=${WORKDIR}

src_install() {
	cp -r "${S}"/* "${D}"/ || die "install failed"
	cd "${D}"/usr
	mkdir share
	mv man share
}

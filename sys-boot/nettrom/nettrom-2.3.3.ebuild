# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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

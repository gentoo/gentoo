# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="SCSIPing pings a host on the SCSI-chain"
HOMEPAGE="http://www.vanheusden.com/Linux/"
SRC_URI="http://www.vanheusden.com/Linux/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""
RDEPEND=""
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	sed -i -e '/strip scsiping/d' ${S}/Makefile
}

src_compile() {
	emake DEBUG='' CFLAGS="${CFLAGS}"
}

src_install() {
	dosbin scsiping
}

pkg_postinst() {
	ewarn "WARNING: using scsiping on a device with mounted partitions may be hazardous to your system!"
}

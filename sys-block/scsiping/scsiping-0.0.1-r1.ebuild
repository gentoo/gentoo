# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="SCSIPing pings a host on the SCSI-chain"
HOMEPAGE="https://www.vanheusden.com/Linux/"
SRC_URI="https://www.vanheusden.com/Linux/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""
RDEPEND=""
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e '/strip scsiping/d' "${S}"/Makefile
	default
}

src_compile() {
	emake DEBUG='' CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dosbin scsiping
}

pkg_postinst() {
	ewarn "WARNING: using scsiping on a device with mounted partitions may be hazardous to your system!"
}

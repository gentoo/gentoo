# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-firmware/zd1211-firmware/zd1211-firmware-1.4.ebuild,v 1.1 2013/02/11 14:13:34 ssuominen Exp $

EAPI=5

DESCRIPTION="Firmware for ZyDAS ZD1211 USB-WLAN devices supported by the zd1211rw driver"
HOMEPAGE="http://zd1211.ath.cx/wiki/DriverRewrite"
SRC_URI="mirror://sourceforge/zd1211/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~sparc x86"
IUSE=""

S=${WORKDIR}/${PN}

src_install() {
	insinto /lib/firmware/zd1211
	doins zd1211_u{b,r,phr} zd1211b_u{b,r,phr}
	dodoc README
}

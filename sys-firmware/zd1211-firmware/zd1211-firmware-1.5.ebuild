# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Firmware for ZyDAS ZD1211 USB-WLAN devices supported by the zd1211rw driver"
HOMEPAGE="http://sourceforge.net/projects/zd1211/"
SRC_URI="mirror://sourceforge/zd1211/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

S=${WORKDIR}/${PN}

src_install() {
	insinto /lib/firmware/zd1211
	doins zd1211_u{b,r,phr} zd1211b_u{b,r,phr}
	dodoc README
}

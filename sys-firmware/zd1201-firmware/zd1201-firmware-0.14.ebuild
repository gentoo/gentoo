# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_P=zd1201-${PV}-fw

DESCRIPTION="Firmware for ZyDAS 1201 based USB 802.11b Network WiFi devices"
HOMEPAGE="http://linux-lc100020.sourceforge.net/"
SRC_URI="mirror://sourceforge/linux-lc100020/${MY_P}.tar.gz"

LICENSE="|| ( GPL-3 MPL-1.1 )"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_compile() { :; }

src_install() {
	insinto /lib/firmware
	doins zd1201{,-ap}.fw
	dodoc README
}

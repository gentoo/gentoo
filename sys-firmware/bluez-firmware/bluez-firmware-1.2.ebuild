# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Firmware for Broadcom BCM203x and STLC2300 Bluetooth chips"
HOMEPAGE="http://bluez.sourceforge.net/"
SRC_URI="http://bluez.sourceforge.net/download/${P}.tar.gz"

RESTRICT="bindist mirror"

LICENSE="bluez-firmware"
SLOT="0"
KEYWORDS="amd64 hppa ppc x86"
IUSE=""

DOCS="AUTHORS ChangeLog README"

src_configure() {
	econf --libdir=/lib
}

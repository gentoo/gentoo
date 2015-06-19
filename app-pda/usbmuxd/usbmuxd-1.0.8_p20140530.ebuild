# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/usbmuxd/usbmuxd-1.0.8_p20140530.ebuild,v 1.2 2014/08/03 12:09:08 ssuominen Exp $

EAPI=5
AUTOTOOLS_AUTORECONF=1
inherit autotools-utils udev user

DESCRIPTION="USB multiplex daemon for use with Apple iPhone/iPod Touch devices"
HOMEPAGE="http://www.libimobiledevice.org/"
#SRC_URI="http://www.libimobiledevice.org/downloads/${P}.tar.bz2"
SRC_URI="http://dev.gentoo.org/~ssuominen/${P}.tar.xz"

# src/utils.h is LGPL-2.1+, rest is found in COPYING*
LICENSE="GPL-2 GPL-3 LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"
IUSE=""

RDEPEND=">=app-pda/libimobiledevice-1.1.6
	>=app-pda/libplist-1.11
	virtual/libusb:1"
DEPEND="${RDEPEND}
	virtual/os-headers
	virtual/pkgconfig"

pkg_setup() {
	enewgroup plugdev
	enewuser usbmux -1 -1 -1 "usb,plugdev"
}

src_install() {
	autotools-utils_src_install udevrulesdir="$(get_udevdir)"/rules.d
}

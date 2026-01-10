# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools udev git-r3

DESCRIPTION="USB multiplex daemon for use with Apple iPhone/iPod Touch devices"
HOMEPAGE="https://libimobiledevice.org/"
EGIT_REPO_URI="https://github.com/libimobiledevice/usbmuxd.git"

LICENSE="|| ( GPL-2 GPL-3 ) LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86"

DEPEND="
	app-pda/libimobiledevice
	app-pda/libimobiledevice-glue
	app-pda/libplist
	virtual/libusb
"

RDEPEND="
	${DEPEND}
	acct-user/usbmux
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --without-udevrulesdir
}

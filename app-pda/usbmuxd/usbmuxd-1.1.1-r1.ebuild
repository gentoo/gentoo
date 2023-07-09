# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd udev

DESCRIPTION="USB multiplex daemon for use with Apple iPhone/iPod Touch devices"
HOMEPAGE="https://libimobiledevice.org/"
SRC_URI="https://github.com/libimobiledevice/usbmuxd/releases/download/${PV}/${P}.tar.bz2"

# src/utils.h is LGPL-2.1+, rest is found in COPYING*
LICENSE="|| ( GPL-2 GPL-3 ) LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="selinux systemd"

DEPEND="
	acct-user/usbmux
	>=app-pda/libimobiledevice-1.3.0:=
	>=app-pda/libplist-2.2:=
	virtual/libusb:1=
"

RDEPEND="
	${DEPEND}
	virtual/udev
	selinux? ( sec-policy/selinux-usbmuxd )
	systemd? ( sys-apps/systemd )
"

BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	econf \
		"$(use_with systemd)" \
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)" \
		--with-udevrulesdir="$(get_udevdir)"/rules.d
}

pkg_postrm() {
	udev_reload
}

pkg_postinst() {
	udev_reload
}

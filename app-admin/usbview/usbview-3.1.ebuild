# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info xdg

DESCRIPTION="Display the topology of devices on the USB bus"
HOMEPAGE="http://www.kroah.com/linux-usb/ https://github.com/gregkh/usbview"
SRC_URI="http://www.kroah.com/linux-usb/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ppc ppc64 sparc x86"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/imagemagick-tools[png,svg]
	virtual/pkgconfig"

CONFIG_CHECK="~DEBUG_FS"

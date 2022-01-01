# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools gnome2

DESCRIPTION="GUI for accessing the Wintec WBT 201 / G-Rays 2 GPS device"
HOMEPAGE="http://www.daria.co.uk/gps"
SRC_URI="http://www.zen35309.zen.co.uk/gps/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-libs/dbus-glib
	dev-libs/glib:2
	dev-libs/libgudev
	net-wireless/bluez
	x11-libs/cairo
	x11-libs/gtk+:3
	virtual/freedesktop-icon-theme"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	default

	# werror is bad idea
	sed -i -e 's:-Werror::g' configure.ac || die
	# we run this ourselves
	sed -i -e '/gtk-update-icon-cache/d' Makefile.am || die
	eautoreconf
}

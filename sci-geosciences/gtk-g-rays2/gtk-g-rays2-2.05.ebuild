# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools gnome2

DESCRIPTION="GUI for accessing the Wintec WBT 201 / G-Rays 2 GPS device"
HOMEPAGE="http://www.daria.co.uk/gps"
SRC_URI="http://www.zen35309.zen.co.uk/gps/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	dev-libs/dbus-glib
	virtual/libgudev
	x11-libs/cairo
	x11-libs/gtk+:3
	virtual/freedesktop-icon-theme
	net-wireless/bluez
"
DEPEND="${DEPEND}
	virtual/pkgconfig
	sys-devel/gettext
"

DOCS="README AUTHORS ChangeLog"

src_prepare() {
	# werror is bad idea
	sed -i -e 's:-Werror::g' configure.ac || die
	# we run this ourselves
	sed -i -e '/gtk-update-icon-cache/d' Makefile.am || die
	eautoreconf
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
}

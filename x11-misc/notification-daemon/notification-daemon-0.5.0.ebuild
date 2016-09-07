# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG=no
GNOME2_LA_PUNT=yes
GNOME_TARBALL_SUFFIX=bz2

inherit autotools eutils gnome2

DESCRIPTION="Notification daemon"
HOMEPAGE="https://git.gnome.org/browse/notification-daemon/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="sh"
IUSE=""

RDEPEND=">=dev-libs/glib-2
	>=x11-libs/gtk+-2.18:2
	>=gnome-base/gconf-2
	>=dev-libs/dbus-glib-0.100
	>=sys-apps/dbus-1
	>=media-libs/libcanberra-0.4[gtk]
	x11-libs/libnotify
	x11-libs/libwnck:1
	x11-libs/libX11
	!x11-misc/notify-osd
	!x11-misc/qtnotifydaemon"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.50
	gnome-base/gnome-common
	>=sys-devel/gettext-0.18
	virtual/pkgconfig"

DOCS="AUTHORS ChangeLog NEWS"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-libnotify-0.7.patch \
		"${FILESDIR}"/${P}-underlinking.patch

	eautoreconf

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure --disable-static
}

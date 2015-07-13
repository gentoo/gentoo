# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/nm-applet/nm-applet-1.0.2.ebuild,v 1.5 2015/07/13 20:28:51 pacho Exp $

EAPI=5
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
GNOME_ORG_MODULE="network-manager-applet"

inherit gnome2

DESCRIPTION="GNOME applet for NetworkManager"
HOMEPAGE="https://wiki.gnome.org/Projects/NetworkManager"

LICENSE="GPL-2+"
SLOT="0"
IUSE="bluetooth +introspection modemmanager"
KEYWORDS="~alpha amd64 ~arm ~ppc ~ppc64 ~sparc x86"

RDEPEND="
	app-crypt/libsecret
	>=dev-libs/glib-2.32:2
	>=dev-libs/dbus-glib-0.88
	>=sys-apps/dbus-1.4.1
	>=sys-auth/polkit-0.96-r1
	>=x11-libs/gtk+-3.4:3[introspection?]
	>=x11-libs/libnotify-0.7.0

	app-text/iso-codes
	>=net-misc/networkmanager-1.0.0[introspection?]
	net-misc/mobile-broadband-provider-info

	bluetooth? ( >=net-wireless/gnome-bluetooth-2.27.6:= )
	introspection? ( >=dev-libs/gobject-introspection-0.9.6:= )
	modemmanager? ( >=net-misc/modemmanager-0.7.990 )
	virtual/freedesktop-icon-theme
	virtual/libgudev:=
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-util/intltool-0.40
"

PDEPEND="virtual/notification-daemon" #546134

src_configure() {
	gnome2_src_configure \
		--disable-more-warnings \
		--disable-static \
		--disable-migration \
		--localstatedir=/var \
		$(use_with bluetooth) \
		$(use_enable introspection) \
		$(use_with modemmanager modem-manager-1)
}

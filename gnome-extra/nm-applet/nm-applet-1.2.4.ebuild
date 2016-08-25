# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GNOME2_LA_PUNT="yes"
GNOME_ORG_MODULE="network-manager-applet"

inherit gnome2

DESCRIPTION="GNOME applet for NetworkManager"
HOMEPAGE="https://wiki.gnome.org/Projects/NetworkManager"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+introspection"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	app-crypt/libsecret
	>=dev-libs/glib-2.32:2[dbus]
	>=dev-libs/dbus-glib-0.88
	>=sys-apps/dbus-1.4.1
	>=sys-auth/polkit-0.96-r1
	>=x11-libs/gtk+-3.4:3[introspection?]
	>=x11-libs/libnotify-0.7.0

	app-text/iso-codes
	>=net-misc/networkmanager-1.2:=[introspection?]
	net-misc/mobile-broadband-provider-info

	introspection? ( >=dev-libs/gobject-introspection-0.9.6:= )
	virtual/freedesktop-icon-theme
	virtual/libgudev:=
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-util/intltool-0.50.1
"

PDEPEND="virtual/notification-daemon" #546134

src_configure() {
	gnome2_src_configure \
		--without-appindicator \
		--disable-more-warnings \
		--disable-static \
		--localstatedir=/var \
		$(use_enable introspection)
}

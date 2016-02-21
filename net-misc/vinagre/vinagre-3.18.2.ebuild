# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2 linux-info vala

DESCRIPTION="VNC client for the GNOME desktop"
HOMEPAGE="https://wiki.gnome.org/Apps/Vinagre"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ~ppc ~ppc64 ~x86"
IUSE="rdp +ssh spice +telepathy zeroconf"

# cairo used in vinagre-tab
# gdk-pixbuf used all over the place
RDEPEND="
	>=dev-libs/glib-2.28.0:2
	>=x11-libs/gtk+-3.9.6:3
	app-crypt/libsecret
	>=dev-libs/libxml2-2.6.31:2
	>=net-libs/gtk-vnc-0.4.3[gtk3]
	x11-libs/cairo:=
	x11-libs/gdk-pixbuf:2
	x11-themes/hicolor-icon-theme

	rdp? ( net-misc/freerdp )
	ssh? ( >=x11-libs/vte-0.20:2.91 )
	spice? (
		app-emulation/spice-protocol
		>=net-misc/spice-gtk-0.5[gtk3] )
	telepathy? (
		dev-libs/dbus-glib
		>=net-libs/telepathy-glib-0.11.6 )
	zeroconf? ( >=net-dns/avahi-0.6.26[dbus,gtk3] )
"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	dev-libs/appstream-glib
	>=dev-util/intltool-0.50
	dev-util/itstool
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	$(vala_depend)
"

pkg_pretend() {
	# Needed for VNC ssh tunnel, bug #518574
	CONFIG_CHECK="~IPV6"
	check_extra_config
}

src_prepare() {
	vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS ChangeLog ChangeLog.pre-git NEWS README"
	gnome2_src_configure \
		$(use_enable rdp) \
		$(use_enable ssh) \
		$(use_enable spice) \
		$(use_with telepathy) \
		$(use_with zeroconf avahi)
}

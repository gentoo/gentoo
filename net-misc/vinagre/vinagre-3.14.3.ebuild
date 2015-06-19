# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/vinagre/vinagre-3.14.3.ebuild,v 1.6 2015/03/15 13:32:22 pacho Exp $

EAPI="5"
GCONF_DEBUG="no"
VALA_MIN_API_VERSION=0.18

inherit gnome2 vala

DESCRIPTION="VNC client for the GNOME desktop"
HOMEPAGE="https://wiki.gnome.org/Apps/Vinagre"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ~ppc ~ppc64 x86"
IUSE="avahi rdp +ssh spice +telepathy"

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

	avahi? ( >=net-dns/avahi-0.6.26[dbus,gtk3] )
	rdp? ( net-misc/freerdp )
	ssh? ( >=x11-libs/vte-0.20:2.91 )
	spice? (
		app-emulation/spice-protocol
		>=net-misc/spice-gtk-0.5[gtk3] )
	telepathy? (
		dev-libs/dbus-glib
		>=net-libs/telepathy-glib-0.11.6 )
"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	dev-libs/appstream-glib
	>=dev-util/intltool-0.50
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	$(vala_depend)
"

src_prepare() {
	# Fix RDP initialization with recent FreeRDP (from 'master')
	epatch "${FILESDIR}"/${PN}-3.14.3-freerdp.patch

	vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS ChangeLog ChangeLog.pre-git NEWS README"
	gnome2_src_configure \
		$(use_with avahi) \
		$(use_enable rdp) \
		$(use_enable ssh) \
		$(use_enable spice) \
		$(use_with telepathy) \
		ITSTOOL=$(type -P true)
}

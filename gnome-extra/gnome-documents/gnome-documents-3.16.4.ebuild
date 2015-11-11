# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"

inherit autotools eutils gnome2

DESCRIPTION="A document manager application for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Documents"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""
KEYWORDS="amd64 ~x86"

# Need gdk-pixbuf-2.25 for gdk_pixbuf_get_pixels_with_length
COMMON_DEPEND="
	>=app-misc/tracker-1:=
	>=app-text/evince-3.13.3[introspection]
	dev-libs/gjs
	>=dev-libs/glib-2.39.3:2
	>=dev-libs/gobject-introspection-1.31.6:=
	>=dev-libs/libgdata-0.13.3:=[gnome,introspection]
	gnome-base/gnome-desktop:3=
	>=media-libs/clutter-1.10:1.0
	>=media-libs/clutter-gtk-1.3.2:1.0[introspection]
	>=net-libs/gnome-online-accounts-3.2.0
	>=net-libs/libsoup-2.41.3:2.4
	>=net-libs/libzapojit-0.0.2
	>=net-libs/webkit-gtk-2.6:4
	>=x11-libs/gdk-pixbuf-2.25:2[introspection]
	>=x11-libs/gtk+-3.15.5:3[introspection]
	x11-libs/pango[introspection]
"
RDEPEND="${COMMON_DEPEND}
	media-libs/clutter[introspection]
	net-misc/gnome-online-miners
	sys-apps/dbus
	x11-themes/gnome-icon-theme-symbolic
"
DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt
	>=dev-util/intltool-0.50.1
	dev-util/itstool
	virtual/pkgconfig

	app-text/yelp-tools
"
# eautoreconf requires yelp-tools

src_prepare() {
	# https://bugzilla.gnome.org/show_bug.cgi?id=750334
	epatch "${FILESDIR}"/${PN}-3.16.2-parallel-make.patch
	eautoreconf
	gnome2_src_prepare
}

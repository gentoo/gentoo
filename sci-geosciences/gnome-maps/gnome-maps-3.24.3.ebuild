# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="A map application for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Maps"

LICENSE="GPL-2+ LGPL-2+ MIT CC-BY-3.0 CC-BY-SA-3.0"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="
	>=app-misc/geoclue-0.12.99:2.0[introspection]
	>=dev-libs/folks-0.10
	>=dev-libs/gjs-1.44.0
	>=dev-libs/gobject-introspection-0.6.3:=
	>=dev-libs/glib-2.39.3:2
	>=dev-libs/libgee-0.16:0.8[introspection]
	dev-libs/libxml2:2
	>=media-libs/libchamplain-0.12.14:0.12[gtk,introspection]
	>=net-libs/rest-0.7.90:0.7[introspection]
	>=sci-geosciences/geocode-glib-3.15.2[introspection]
	>=x11-libs/gtk+-3.22:3[introspection]
"
# Found by grepping imports.gi in ${S}
RDEPEND="${COMMON_DEPEND}
	app-crypt/libsecret[introspection]
	dev-libs/libgweather[introspection]
	media-libs/clutter-gtk:1.0[introspection]
	media-libs/clutter:1.0[introspection]
	media-libs/cogl:1.0[introspection]
	net-libs/gnome-online-accounts[introspection]
	net-libs/libgfbgraph[introspection]
	net-libs/libsoup:2.4[introspection]
	net-libs/webkit-gtk:4[introspection]
	x11-libs/gdk-pixbuf:2[introspection]
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40
	virtual/pkgconfig
"

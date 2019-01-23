# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="A map application for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Maps"

LICENSE="GPL-2+ LGPL-2+ MIT CC-BY-3.0 CC-BY-SA-3.0"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

# Pure introspection dependencies found by grepping imports.gi in ${S}
RDEPEND="
	>=dev-libs/glib-2.44.0:2
	>=dev-libs/gjs-1.50.0
	>=dev-libs/gobject-introspection-0.10.1:=
	>=x11-libs/gtk+-3.22:3[introspection]
	>=app-misc/geoclue-0.12.99:2.0[introspection]
	>=dev-libs/libgee-0.16:0.8[introspection]
	>=dev-libs/folks-0.10
	>=sci-geosciences/geocode-glib-3.15.2[introspection]
	>=media-libs/libchamplain-0.12.14:0.12[gtk,introspection]
	dev-libs/libxml2:2
	>=net-libs/rest-0.7.90:0.7[introspection]

	app-crypt/libsecret[introspection]
	dev-libs/libgweather[introspection]
	media-libs/clutter-gtk:1.0[introspection]
	media-libs/clutter:1.0[introspection]
	net-libs/gnome-online-accounts[introspection]
	net-libs/libgfbgraph[introspection]
	net-libs/libsoup:2.4[introspection]
	net-libs/webkit-gtk:4[introspection]
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
"

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
	gnome2_icon_cache_update
}

pkg_postinst() {
	xdg_pkg_postrm
	gnome2_schemas_update
	gnome2_icon_cache_update
}

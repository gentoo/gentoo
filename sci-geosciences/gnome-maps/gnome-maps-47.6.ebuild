# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="Map application for GNOME using OpenStreetMap data"
HOMEPAGE="https://apps.gnome.org/Maps/"

LICENSE="GPL-2+ LGPL-2.1 CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

# Pure introspection dependencies found by grepping imports in ${S}
RDEPEND="
	app-crypt/libsecret[introspection]
	app-misc/geoclue:2.0[introspection]
	dev-libs/gjs
	dev-libs/glib:2
	dev-libs/gobject-introspection:=
	dev-libs/json-glib
	dev-libs/libportal:=[introspection]
	dev-libs/libgweather:4=[introspection]
	dev-libs/libxml2:2
	gnome-base/librsvg:2
	gui-libs/gtk:4[introspection]
	>=gui-libs/libadwaita-1.5:1[introspection]
	>=sci-geosciences/geocode-glib-3.15.2:2[introspection]
	media-libs/graphene[introspection]
	media-libs/libshumate:1.0=[introspection]
	net-libs/libsoup:3.0[introspection]
	net-libs/rest:1.0[introspection]
	x11-libs/cairo[glib]
	x11-libs/pango[introspection]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}

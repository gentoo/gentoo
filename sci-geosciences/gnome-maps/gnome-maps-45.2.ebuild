# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="A map application for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Maps"

LICENSE="GPL-2+ LGPL-2+ MIT CC-BY-3.0 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

# Pure introspection dependencies found by grepping imports in ${S}
RDEPEND="
	>=dev-libs/glib-2.66.0:2
	>=dev-libs/gjs-1.69.2
	>=dev-libs/gobject-introspection-0.10.1:=
	gui-libs/gtk:4[introspection]
	>=app-misc/geoclue-0.12.99:2.0[introspection]
	>=gui-libs/libadwaita-1.4_alpha:1[introspection]
	>=dev-libs/libgweather-4.2.0:4=[introspection]
	>=sci-geosciences/geocode-glib-3.15.2:2[introspection]
	dev-libs/libportal:=[introspection]
	>=media-libs/libshumate-1.1_beta:1.0=[introspection]
	dev-libs/libxml2:2
	>=net-libs/rest-0.9.1:1.0[introspection]

	app-crypt/libsecret[introspection]
	media-libs/graphene[introspection]
	net-libs/libsoup:3.0[introspection]
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

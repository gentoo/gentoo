# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="A document manager application for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Documents"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""
KEYWORDS="amd64 x86"

# cairo-1.14 for cairo_surface_set_device_scale check and usage
COMMON_DEPEND="
	>=app-text/evince-3.13.3[introspection]
	app-misc/tracker:0/2.0
	>=dev-libs/gjs-1.48.0
	>=dev-libs/glib-2.39.3:2
	gnome-base/gnome-desktop:3=[introspection]
	>=dev-libs/gobject-introspection-1.54:=
	>=x11-libs/gtk+-3.22.15:3[introspection]
	>=net-libs/libsoup-2.41.3:2.4
	>=net-libs/webkit-gtk-2.6:4[introspection]

	>=dev-libs/libgdata-0.13.3:=[crypt,gnome-online-accounts,introspection]
	>=app-text/libgepub-0.6[introspection]
	<app-text/libgepub-0.7
	>=net-libs/gnome-online-accounts-3.2.0[introspection]
	>=net-libs/libzapojit-0.0.2[introspection]

	>=x11-libs/cairo-1.14
	x11-libs/gdk-pixbuf:2[introspection]
	x11-libs/pango[introspection]
"
RDEPEND="${COMMON_DEPEND}
	>=app-misc/tracker-miners-2
	net-misc/gnome-online-miners
	sys-apps/dbus
	x11-themes/adwaita-icon-theme
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xsl-stylesheets
	dev-libs/appstream-glib
	dev-libs/libxslt
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	dev-util/itstool
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Ddocumentation=true #manpage
		-Dgetting_started=false #inkscape and pdfunite build deps
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}

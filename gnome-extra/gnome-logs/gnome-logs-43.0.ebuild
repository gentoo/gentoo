# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="Log viewer for the systemd journal"
HOMEPAGE="https://wiki.gnome.org/Apps/Logs"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~x86"

RDEPEND="
	gnome-base/gsettings-desktop-schemas
	>=dev-libs/glib-2.43.90:2
	>=gui-libs/gtk-4.6.0:4
	>=gui-libs/libadwaita-1.2.0:1
	sys-apps/systemd:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	app-text/docbook-xml-dtd:4.3
	dev-libs/libxml2:2
	dev-libs/libxslt
	dev-util/itstool
	virtual/pkgconfig
"

src_configure() {
	meson_src_configure -Dman=true
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}

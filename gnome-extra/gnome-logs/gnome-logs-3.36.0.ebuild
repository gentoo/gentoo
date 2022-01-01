# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="Log viewer for the systemd journal"
HOMEPAGE="https://wiki.gnome.org/Apps/Logs"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND="
	gnome-base/gsettings-desktop-schemas
	>=dev-libs/glib-2.43.90:2
	>=x11-libs/gtk+-3.22:3
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

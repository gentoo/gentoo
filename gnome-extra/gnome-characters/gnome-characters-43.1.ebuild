# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="Unicode character map viewer and library"
HOMEPAGE="https://wiki.gnome.org/Design/Apps/CharacterMap"

LICENSE="GPL-2+ BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv ~x86"

RDEPEND="
	>=dev-libs/gjs-1.50
	>=dev-libs/glib-2.32:2
	>=dev-libs/gobject-introspection-1.35.9:=
	>=dev-libs/libunistring-0.9.5:=
	>=gui-libs/gtk-4.6:4[introspection]
	>=gui-libs/libadwaita-1.2:1=
	x11-libs/gdk-pixbuf:2
	>=x11-libs/pango-1.36[introspection]
	gnome-base/gnome-desktop:3[introspection]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/libxml2:2
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

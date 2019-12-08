# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_MIN_API_VERSION="0.40"
inherit gnome.org gnome2-utils meson xdg vala

DESCRIPTION="Turn off all the lights"
HOMEPAGE="https://wiki.gnome.org/Apps/Lightsoff"

LICENSE="GPL-2+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.38.0:2
	>=x11-libs/gtk+-3.13.4:3
	>=media-libs/clutter-1.14.0:1.0
	>=media-libs/clutter-gtk-1.5.5:1.0
	>=gnome-base/librsvg-2.32.0:2
"
DEPEND="${RDEPEND}"
# libxml2:2 needed for glib-compile-resources xml-stripblanks attributes
BDEPEND="
	dev-libs/appstream-glib
	dev-libs/libxml2:2
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	$(vala_depend)
	gnome-base/librsvg:2[vala]
"

src_prepare() {
	xdg_src_prepare
	vala_src_prepare
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}

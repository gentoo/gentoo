# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_MIN_API_VERSION="0.44"

inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="Move tiles so that they reach their places"
HOMEPAGE="https://wiki.gnome.org/Apps/Taquin"

LICENSE="GPL-3+ CC-BY-SA-3.0 CC-BY-SA-4.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.42.0:2
	>=media-libs/gsound-1.0.2
	>=x11-libs/gtk+-3.24.0:3
	>=gnome-base/librsvg-2.32.0:2
"
# libxml2+gdk-pixbuf required for glib-compile-resources (xml-stripblanks and to-pixdata)
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/libxml2:2
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	x11-libs/gdk-pixbuf:2
	$(vala_depend)
	media-libs/gsound[vala]
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

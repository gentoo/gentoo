# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_MIN_API_VERSION="0.28"

inherit gnome2 vala

DESCRIPTION="Move tiles so that they reach their places"
HOMEPAGE="https://wiki.gnome.org/Apps/Taquin"

LICENSE="GPL-3+ CC-BY-SA-3.0 CC-BY-SA-4.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.40:2
	>=gnome-base/librsvg-2.32:2
	>=media-libs/libcanberra-0.26[gtk3]
	>=x11-libs/gtk+-3.15:3
"
# libxml2+gdk-pixbuf required for glib-compile-resources
DEPEND="${RDEPEND}
	$(vala_depend)
	app-text/yelp-tools
	dev-libs/appstream-glib
	dev-libs/libxml2:2
	>=dev-util/intltool-0.50
	sys-devel/gettext
	virtual/pkgconfig
	x11-libs/gdk-pixbuf:2
"

src_prepare() {
	gnome2_src_prepare
	vala_src_prepare
}

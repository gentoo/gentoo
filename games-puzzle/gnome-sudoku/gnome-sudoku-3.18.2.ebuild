# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
VALA_MIN_API_VERSION="0.28"

inherit gnome-games vala

DESCRIPTION="Test your logic skills in this number grid puzzle"
HOMEPAGE="https://wiki.gnome.org/Apps/Sudoku"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

# fixed vala & gtk+ from gnome-3.16 branch
RDEPEND="
	>=dev-libs/glib-2.40:2
	dev-libs/libgee:0.8[introspection]
	dev-libs/json-glib
	>=dev-libs/qqwing-1.3.4
	x11-libs/gdk-pixbuf:2[introspection]
	>=x11-libs/gtk+-3.15:3[introspection]
	x11-libs/pango[introspection]
"
DEPEND="${RDEPEND}
	$(vala_depend)
	app-text/yelp-tools
	dev-libs/appstream-glib
	>=dev-util/intltool-0.50
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	vala_src_prepare
	gnome-games_src_prepare
}

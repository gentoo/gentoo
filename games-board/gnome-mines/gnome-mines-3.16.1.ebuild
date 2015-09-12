# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
VALA_MIN_API_VERSION="0.22"

inherit gnome-games vala

DESCRIPTION="Clear hidden mines from a minefield"
HOMEPAGE="https://wiki.gnome.org/Apps/Mines"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

COMMON_DEPEND="
	>=dev-libs/glib-2.40:2
	>=gnome-base/librsvg-2.32.0
	>=x11-libs/gtk+-3.12:3
"
RDEPEND="${COMMON_DEPEND}
	!<x11-themes/gnome-themes-standard-3.14
"
DEPEND="${COMMON_DEPEND}
	$(vala_depend)
	app-text/yelp-tools
	dev-libs/appstream-glib
	>=dev-util/intltool-0.50
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	gnome-games_src_prepare
	vala_src_prepare
}

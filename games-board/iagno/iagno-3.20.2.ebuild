# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
VALA_MIN_API_VERSION="0.28"

inherit gnome2 vala

DESCRIPTION="Dominate the board in a classic version of Reversi"
HOMEPAGE="https://wiki.gnome.org/Apps/Iagno"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

COMMON_DEPEND="
	>=dev-libs/glib-2.40:2
	>=gnome-base/librsvg-2.32.0:2
	>=media-libs/libcanberra-0.26[gtk3]
	>=x11-libs/gtk+-3.15:3
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
	gnome2_src_prepare
	vala_src_prepare
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
VALA_MIN_API_VERSION="0.24"

inherit gnome2 vala

DESCRIPTION="Clocks application for GNOME"
HOMEPAGE="http://live.gnome.org/GnomeClocks"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.39:2
	>=x11-libs/gtk+-3.12:3
	>=media-libs/libcanberra-0.30
	>=dev-libs/libgweather-3.13.91:2=
	>=gnome-base/gnome-desktop-3.7.90:3=
	>=sci-geosciences/geocode-glib-0.99.4
	>=app-misc/geoclue-1.99.3:2.0
"
DEPEND="${RDEPEND}
	$(vala_depend)
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

src_prepare() {
	vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure ITSTOOL=$(type -P true)
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
VALA_MIN_API_VERSION="0.28"

inherit gnome2 vala

DESCRIPTION="Nibbles clone for Gnome"
HOMEPAGE="https://wiki.gnome.org/Apps/Nibbles"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.40.0:2
	dev-libs/libgee:0.8=
	dev-libs/libgnome-games-support:1
	>=media-libs/clutter-1.22.0:1.0
	>=media-libs/clutter-gtk-1.4.0:1.0
	>=media-libs/libcanberra-0.26[gtk3]
	>=x11-libs/gtk+-3.18.0:3
"
DEPEND="${RDEPEND}
	$(vala_depend)
	app-text/yelp-tools
	dev-libs/appstream-glib
	>=dev-util/intltool-0.50.2
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	gnome2_src_prepare
	vala_src_prepare
}

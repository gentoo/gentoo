# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2 vala

DESCRIPTION="Clear the screen by removing groups of colored and shaped tiles"
HOMEPAGE="https://wiki.gnome.org/Apps/Swell%20Foop"

LICENSE="GPL-2+ FDL-1.1+"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.36:2
	>=media-libs/clutter-1.14:1.0
	>=media-libs/clutter-gtk-1.5:1.0
	>=x11-libs/gtk+-3.12:3
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
	gnome2_src_prepare
	vala_src_prepare
}

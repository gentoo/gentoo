# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="Logic puzzle game for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Hitori"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.32:2
	>=x11-libs/gtk+-3.15:3
	>=x11-libs/cairo-1.4
"
DEPEND="${RDEPEND}
	app-text/yelp-tools
	dev-libs/appstream-glib
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

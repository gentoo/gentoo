# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="Make lines of the same color to win"
HOMEPAGE="https://wiki.gnome.org/Apps/Four-in-a-row"

# Code is GPL-2+ but most themes are GPL-3+ and we install them unconditionally, CC-BY-SA-3.0 is user help license in v3.22.1
LICENSE="GPL-3+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	>=gnome-base/librsvg-2.32
	>=media-libs/libcanberra-0.26[gtk3]
	>=x11-libs/gtk+-3.13.2:3
"
DEPEND="${RDEPEND}
	app-text/yelp-tools
	dev-libs/appstream-glib
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

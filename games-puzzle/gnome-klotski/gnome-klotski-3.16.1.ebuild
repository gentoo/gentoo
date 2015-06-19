# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/gnome-klotski/gnome-klotski-3.16.1.ebuild,v 1.1 2015/06/09 15:59:24 eva Exp $

EAPI="5"
GCONF_DEBUG="no"
VALA_MIN_API_VERSION="0.28"

inherit gnome-games vala

DESCRIPTION="Slide blocks to solve the puzzle"
HOMEPAGE="https://wiki.gnome.org/Apps/Klotski"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.32:2
	>=gnome-base/librsvg-2.32.0
	>=x11-libs/gtk+-3.15:3
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
	gnome-games_src_prepare
	vala_src_prepare
}

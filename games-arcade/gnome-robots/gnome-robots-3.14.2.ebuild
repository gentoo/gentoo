# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/gnome-robots/gnome-robots-3.14.2.ebuild,v 1.3 2015/03/15 13:20:17 pacho Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit gnome-games

DESCRIPTION="Avoid the robots and make them crash into each other"
HOMEPAGE="https://wiki.gnome.org/Apps/Robots"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.32:2
	>=gnome-base/librsvg-2.36.2:2
	>=media-libs/libcanberra-0.26[gtk3]
	>=x11-libs/gtk+-3.12:3
"
DEPEND="${RDEPEND}
	app-text/yelp-tools
	dev-util/appdata-tools
	>=dev-util/intltool-0.50
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	gnome-games_src_configure APPDATA_VALIDATE=$(type -P true)
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/hitori/hitori-3.16.1.ebuild,v 1.1 2015/06/09 15:19:56 eva Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit gnome-games

DESCRIPTION="Logic puzzle game for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Hitori"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.32:2
	>=x11-libs/cairo-1.4
	>=x11-libs/gtk+-3.15:3
"
DEPEND="${RDEPEND}
	app-text/yelp-tools
	dev-libs/appstream-glib
	>=dev-util/intltool-0.50.2
	gnome-base/gnome-common
	sys-devel/gettext
	virtual/pkgconfig
"

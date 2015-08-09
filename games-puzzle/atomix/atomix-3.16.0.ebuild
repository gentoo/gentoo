# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit gnome-games

DESCRIPTION="a game where you build full molecules, from simple inorganic to extremely complex organic ones"
HOMEPAGE="http://ftp.gnome.org/pub/GNOME/sources/atomix/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.36:2
	>=dev-libs/libxml2-2.4.23
	>=x11-libs/gdk-pixbuf-2.0.5:2
	>=x11-libs/gtk+-3.10:3
"
DEPEND="${RDEPEND}
	dev-libs/appstream-glib
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
"

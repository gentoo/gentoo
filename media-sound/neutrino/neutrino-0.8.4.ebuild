# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit gnome2

DESCRIPTION="A GNOME application to manage Creative music players using the PDE protocol"
HOMEPAGE="http://neutrino.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=gnome-base/libgnome-2
	>=gnome-base/libgnomeui-2
	>=gnome-base/libglade-2
	dev-libs/libxml2
	>=gnome-base/gnome-vfs-2
	>=gnome-base/gconf-2
	>=media-libs/libnjb-2.2
	>=media-libs/id3lib-3.8.3-r6
"
DEPEND="${RDEPEND}
	app-text/rarian
	virtual/pkgconfig
	dev-util/intltool
"

MAKEOPTS="${MAKEOPTS} -j1"

PATCHES=( "${FILESDIR}/${PN}-0.8.4-glib-single-include.patch" )

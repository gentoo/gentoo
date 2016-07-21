# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit gnome2

DESCRIPTION="Easy to use, fast and lightweight mapping application (fork of tangogps)"
HOMEPAGE="http://www.foxtrotgps.org/"
SRC_URI="http://www.foxtrotgps.org/releases/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-libs/libxml2:2
	gnome-base/gconf:2
	gnome-base/libglade
	media-libs/libexif
	net-misc/curl
	>=sci-geosciences/gpsd-2.90
	sys-apps/dbus
	x11-libs/gtk+:2
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

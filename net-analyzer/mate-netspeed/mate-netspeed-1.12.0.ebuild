# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~arm x86"
fi

DESCRIPTION="Applet showing network traffic for MATE"
LICENSE="GPL-2"
SLOT="0"

IUSE="gtk3"

# FIXME: wireless-tools >= 28pre9 is automagic
RDEPEND="dev-libs/glib:2
	>=gnome-base/libgtop-2.14.2:2
	>=mate-base/mate-desktop-1.9[gtk3(-)=]
	>=mate-base/mate-panel-1.7[gtk3(-)=]
	>=net-wireless/wireless-tools-28_pre9:0
	x11-libs/gdk-pixbuf:2
	x11-libs/pango:0
	virtual/libintl:0
	!gtk3? ( x11-libs/gtk+:2 )
	gtk3? ( x11-libs/gtk+:3 )"

DEPEND="${RDEPEND}
	app-text/yelp-tools:0
	>=dev-util/intltool-0.50.1:*
	sys-devel/gettext:*
	virtual/pkgconfig:*"

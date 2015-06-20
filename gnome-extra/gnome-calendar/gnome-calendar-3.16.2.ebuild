# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-calendar/gnome-calendar-3.16.2.ebuild,v 1.2 2015/06/20 03:14:15 tetromino Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Manage your online calendars with simple and modern interface"
HOMEPAGE="https://wiki.gnome.org/Apps/Calendar"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# >=libical-1.0.1 for https://bugzilla.gnome.org/show_bug.cgi?id=751244
RDEPEND="
	>=dev-libs/glib-2.43.4:2
	>=dev-libs/libical-1.0.1
	>=gnome-extra/evolution-data-server-3.13.90
	>=x11-libs/gtk+-3.15.4:3
"
DEPEND="${RDEPEND}
	dev-libs/appstream-glib
	>=dev-util/intltool-0.40.6
	sys-devel/gettext
	virtual/pkgconfig
"

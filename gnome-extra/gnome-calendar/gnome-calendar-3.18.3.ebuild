# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Manage your online calendars with simple and modern interface"
HOMEPAGE="https://wiki.gnome.org/Apps/Calendar"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

# >=libical-1.0.1 for https://bugzilla.gnome.org/show_bug.cgi?id=751244
RDEPEND="
	>=dev-libs/glib-2.43.4:2
	>=dev-libs/libical-1.0.1
	>=gnome-extra/evolution-data-server-3.17.1:=
	>=net-libs/gnome-online-accounts-3.2.0:=
	>=x11-libs/gtk+-3.15.4:3
"
DEPEND="${RDEPEND}
	dev-libs/appstream-glib
	dev-util/gdbus-codegen
	>=dev-util/intltool-0.40.6
	sys-devel/gettext
	virtual/pkgconfig
"

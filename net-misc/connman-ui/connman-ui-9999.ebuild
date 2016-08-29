# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools git-r3

DESCRIPTION="A full-featured GTK based trayicon UI for ConnMan"
HOMEPAGE="https://github.com/tbursztyka/connman-ui"
SRC_URI=""
EGIT_REPO_URI="https://github.com/tbursztyka/connman-ui.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

CDEPEND="
	dev-libs/glib:2
	sys-apps/dbus
	x11-libs/gtk+:3
"
RDEPEND="${CDEPEND}
	net-misc/connman
"
DEPEND="${CDEPEND}
	dev-util/intltool
	virtual/pkgconfig
"

src_prepare() {
	default
	eautoreconf
}

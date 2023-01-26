# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools git-r3

DESCRIPTION="A full-featured GTK based trayicon UI for ConnMan"
HOMEPAGE="https://github.com/tbursztyka/connman-ui"
EGIT_REPO_URI="https://github.com/tbursztyka/connman-ui.git"

LICENSE="GPL-2"
SLOT="0"

COMMON_DEPEND="
	dev-libs/glib:2
	sys-apps/dbus
	x11-libs/gtk+:3
"
RDEPEND="
	${COMMON_DEPEND}
	net-misc/connman
"
DEPEND="
	${COMMON_DEPEND}
	dev-util/intltool
	virtual/pkgconfig
"

src_prepare() {
	default
	eautoreconf
}

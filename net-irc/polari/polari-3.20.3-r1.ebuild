# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit gnome2

DESCRIPTION="An IRC client for Gnome"
HOMEPAGE="https://wiki.gnome.org/Apps/Polari"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

COMMON_DEPEND="
	>=dev-libs/gjs-1.45.3
	>=dev-libs/glib-2.43.4:2
	>=dev-libs/gobject-introspection-0.9.6:=
	net-libs/telepathy-glib[introspection]
	>=x11-libs/gtk+-3.19.12:3[introspection]
"
RDEPEND="${COMMON_DEPEND}
	>=net-irc/telepathy-idle-0.2
	net-im/telepathy-logger[introspection]
"
DEPEND="${COMMON_DEPEND}
	dev-libs/appstream-glib
	>=dev-util/intltool-0.50
	virtual/pkgconfig
"

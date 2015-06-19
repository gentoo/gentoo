# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/polari/polari-3.16.1.ebuild,v 1.1 2015/06/09 22:43:37 eva Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="An IRC client for Gnome"
HOMEPAGE="https://wiki.gnome.org/Apps/Polari"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-libs/gjs
	>=dev-libs/glib-2.43.4:2
	>=dev-libs/gobject-introspection-0.9.6
	net-libs/telepathy-glib[introspection]
	>=x11-libs/gtk+-3.15.6:3[introspection]
"
DEPEND="${RDEPEND}
	dev-libs/appstream-glib
	>=dev-util/intltool-0.50
	virtual/pkgconfig
"

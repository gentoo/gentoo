# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/moserial/moserial-3.0.8.ebuild,v 1.4 2013/03/26 16:53:54 ago Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="A clean and friendly gtk-based serial terminal"
HOMEPAGE="https://live.gnome.org/moserial"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.16:2
	gnome-base/gsettings-desktop-schemas
	>=x11-libs/gtk+-3.0.0:3"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.3.2
	>=dev-util/intltool-0.35
	virtual/pkgconfig"

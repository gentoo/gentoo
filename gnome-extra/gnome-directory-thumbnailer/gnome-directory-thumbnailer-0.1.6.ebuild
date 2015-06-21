# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-directory-thumbnailer/gnome-directory-thumbnailer-0.1.6.ebuild,v 1.2 2015/06/21 12:57:49 zlogene Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Thumbnail generator for directories"
HOMEPAGE="https://wiki.gnome.org/GnomeDirectoryThumbnailer"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE=""
KEYWORDS="amd64"

RDEPEND="
	>=dev-libs/glib-2.35:2
	>=x11-libs/gdk-pixbuf-2.6:2
	>=gnome-base/gnome-desktop-2.2:3=
	x11-libs/gtk+:3
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	virtual/pkgconfig
"

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="A Gtk+ front-end to the Valgrind memory checker"
HOMEPAGE="http://alleyoop.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-alpha amd64 ~ppc -sparc x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.14:2
	>=x11-libs/gtk+-2.2:2
	>=gnome-base/gconf-2.2:2
	>=gnome-base/libgnomeui-2.2
	>=gnome-base/libglade-2.2
	gnome-base/libgnome-keyring
	sys-devel/binutils
	>=dev-util/valgrind-2.4
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

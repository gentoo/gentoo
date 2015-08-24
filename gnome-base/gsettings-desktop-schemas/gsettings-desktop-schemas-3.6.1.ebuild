# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Collection of GSettings schemas for GNOME desktop"
HOMEPAGE="https://www.gnome.org/"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="+introspection"
KEYWORDS="sh"

RDEPEND=">=dev-libs/glib-2.31:2
	introspection? ( >=dev-libs/gobject-introspection-1.31.0 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.40
	virtual/pkgconfig"

src_configure() {
	G2CONF="${G2CONF}
		$(use_enable introspection)"
	DOCS="AUTHORS HACKING NEWS README"
	gnome2_src_configure
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2 multilib

DESCRIPTION="GObject-based interfaces and classes for commonly used data structures"
HOMEPAGE="https://live.gnome.org/Libgee"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="sh"
IUSE="+introspection"

RDEPEND=">=dev-libs/glib-2.12:2
	introspection? ( >=dev-libs/gobject-introspection-0.9.6:= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	DOCS="AUTHORS ChangeLog* MAINTAINERS NEWS README"
	G2CONF+=" $(use_enable introspection)"
	gnome2_src_prepare
}

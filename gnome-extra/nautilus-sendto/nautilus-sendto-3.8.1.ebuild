# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="yes"

inherit gnome2

DESCRIPTION="A nautilus extension for sending files to locations"
HOMEPAGE="https://www.gnome.org"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="+introspection"

RDEPEND="
	>=x11-libs/gtk+-2.90.3:3[X(+)]
	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.9
	>=dev-util/intltool-0.35
	sys-devel/gettext
	virtual/pkgconfig
"
# Needed for eautoreconf
#	>=gnome-base/gnome-common-0.12

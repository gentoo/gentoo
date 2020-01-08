# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="LibGRSS is a library for easy management of RSS/Atom/Pie feeds"
HOMEPAGE="https://wiki.gnome.org/Projects/Libgrss"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="+introspection"

RDEPEND="
	>=dev-libs/glib-2.42.1:2
	>=dev-libs/libxml2-2.9.2:2
	>=net-libs/libsoup-2.48:2.4
	introspection? ( >=dev-libs/gobject-introspection-1.42 )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.10
	virtual/pkgconfig
"

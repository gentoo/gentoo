# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit gnome2

DESCRIPTION="GObject-based interfaces and classes for commonly used data structures"
HOMEPAGE="https://wiki.gnome.org/Projects/Libgee"

LICENSE="LGPL-2.1+"
SLOT="0.8/2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-linux"
IUSE="+introspection"

# FIXME: add doc support, requires valadoc
RDEPEND="
	>=dev-libs/glib-2.36:2
	introspection? ( >=dev-libs/gobject-introspection-0.9.6:= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure \
		$(use_enable introspection)
		VALAC="$(type -P false)"
}

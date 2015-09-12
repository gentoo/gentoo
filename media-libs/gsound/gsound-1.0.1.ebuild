# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
VALA_USE_DEPEND="vapigen"
VALA_MIN_API_VERSION="0.20"

inherit gnome2 vala

DESCRIPTION="Thin GObject wrapper around the libcanberra sound event library"
HOMEPAGE="https://wiki.gnome.org/Projects/GSound"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+introspection"

# vala setup required for vapigen check
RDEPEND="
	>=dev-libs/glib-2.36:2
	media-libs/libcanberra
	introspection? ( >=dev-libs/gobject-introspection-1.2.9 )
"
DEPEND="${RDEPEND}
	$(vala_depend)
	>=dev-util/gtk-doc-am-1.20
	virtual/pkgconfig
"

src_prepare() {
	vala_src_prepare
	gnome2_src_prepare
}

src_configure () {
	gnome2_src_configure \
		--disable-static \
		$(use_enable introspection)
}

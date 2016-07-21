# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
GNOME_ORG_MODULE="gfbgraph"

inherit gnome2

DESCRIPTION="A GObject library for Facebook Graph API"
HOMEPAGE="https://git.gnome.org/browse/libgfbgraph/"

LICENSE="LGPL-2.1+"
SLOT="0.2"
KEYWORDS="amd64 x86"
IUSE="+introspection"

RDEPEND="
	dev-libs/glib:2
	dev-libs/json-glib
	net-libs/libsoup:2.4
	net-libs/gnome-online-accounts
	net-libs/rest:0.7
	introspection? ( >=dev-libs/gobject-introspection-1.30:= )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.14
	virtual/pkgconfig
"

# FIXME: most tests seem to fail
RESTRICT="test"

src_configure() {
	gnome2_src_configure --disable-static
}

src_install() {
	gnome2_src_install
	# Remove files installed in the wrong place
	# Also, already done by portage
	# https://bugzilla.gnome.org/show_bug.cgi?id=752581
	rm -rf "${ED}"/usr/doc
}

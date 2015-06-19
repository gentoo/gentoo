# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/telepathy-farstream/telepathy-farstream-0.6.2.ebuild,v 1.4 2015/02/12 11:47:36 pacho Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Telepathy client library that uses Farstream to handle Call channels"
HOMEPAGE="http://telepathy.freedesktop.org"
SRC_URI="http://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/3"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="examples +introspection"

RDEPEND="
	>=dev-libs/glib-2.32:2
	>=sys-apps/dbus-0.60
	>=dev-libs/dbus-glib-0.60
	media-libs/gstreamer:1.0[introspection?]
	>=net-libs/telepathy-glib-0.21[introspection?]
	net-libs/farstream:0.2=[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-1.30 )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.17
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--disable-Werror \
		$(use_enable introspection)
}

src_install() {
	gnome2_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*.c
		insinto /usr/share/doc/${PF}/examples/python
		doins examples/python/*.py
	fi
}

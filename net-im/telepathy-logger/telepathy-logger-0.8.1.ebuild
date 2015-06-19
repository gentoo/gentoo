# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/telepathy-logger/telepathy-logger-0.8.1.ebuild,v 1.4 2015/04/08 18:03:12 mgorny Exp $

EAPI="5"
GCONF_DEBUG="no"
PYTHON_COMPAT=( python2_7 )

inherit gnome2 python-any-r1 virtualx

DESCRIPTION="Telepathy Logger is a session daemon that should be activated whenever telepathy is being used"
HOMEPAGE="http://telepathy.freedesktop.org/wiki/Logger"
SRC_URI="http://telepathy.freedesktop.org/releases/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1+"
SLOT="0/3"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-linux"
IUSE="+introspection"

RDEPEND="
	>=dev-libs/glib-2.28:2
	>=sys-apps/dbus-1.1
	>=dev-libs/dbus-glib-0.82
	>=net-libs/telepathy-glib-0.19.2[introspection?]
	dev-libs/libxml2
	dev-libs/libxslt
	dev-db/sqlite:3
	introspection? ( >=dev-libs/gobject-introspection-0.9.6 )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	>=dev-util/gtk-doc-am-1.10
	>=dev-util/intltool-0.35
	virtual/pkgconfig
"

src_configure() {
	# --enable-debug needed due https://bugs.freedesktop.org/show_bug.cgi?id=83390
	gnome2_src_configure \
		$(use_enable introspection) \
		--enable-debug \
		--enable-public-extensions \
		--disable-coding-style-checks \
		--disable-Werror \
		--disable-static
}

src_test() {
	Xemake check
}

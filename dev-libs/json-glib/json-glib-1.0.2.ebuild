# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="A library providing GLib serialization and deserialization support for the JSON format"
HOMEPAGE="https://wiki.gnome.org/Projects/JsonGlib"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="debug +introspection"

RDEPEND="
	>=dev-libs/glib-2.37.6:2
	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
"
DEPEND="${RDEPEND}
	~app-text/docbook-xml-dtd-4.1.2
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	>=dev-util/gtk-doc-am-1.20
	>=sys-devel/gettext-0.18
	virtual/pkgconfig
"

src_prepare() {
	# Do not touch CFLAGS
	sed -e 's/CFLAGS -g/CFLAGS/' -i "${S}"/configure || die
}

src_configure() {
	# Coverage support is useless, and causes runtime problems
	gnome2_src_configure \
		--enable-man \
		--disable-gcov \
		$(usex debug --enable-debug=yes --enable-debug=minimum) \
		$(use_enable introspection)
}

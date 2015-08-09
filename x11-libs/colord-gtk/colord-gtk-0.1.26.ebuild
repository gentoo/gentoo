# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
VALA_USE_DEPEND="vapigen"

inherit gnome2 vala

DESCRIPTION="GTK support library for colord"
HOMEPAGE="http://www.freedesktop.org/software/colord/"
SRC_URI="http://www.freedesktop.org/software/colord/releases/${P}.tar.xz"

LICENSE="LGPL-3+"
SLOT="0/1" # subslot = libcolord-gtk soname version
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"

# We still need to build gtk-doc, https://bugs.freedesktop.org/show_bug.cgi?id=69107
IUSE="doc +introspection vala"
REQUIRED_USE="vala? ( introspection )"

COMMON_DEPEND="
	>=dev-libs/glib-2.28:2
	>=media-libs/lcms-2.2:2=
	x11-libs/gdk-pixbuf:2[introspection?]
	x11-libs/gtk+:3[X(+),introspection?]
	x11-misc/colord:=[introspection?,vala?]
	introspection? ( >=dev-libs/gobject-introspection-0.9.8 )
"
# ${PN} was part of x11-misc/colord until 0.1.22
RDEPEND="${COMMON_DEPEND}
	!<x11-misc/colord-0.1.27
"
DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt
	>=dev-util/intltool-0.35
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	doc? (
		app-text/docbook-xml-dtd:4.1.2
		>=dev-util/gtk-doc-1.9
	)
	vala? ( $(vala_depend) )
"

RESTRICT="test" # Tests need a display device with a default color profile set

src_prepare() {
	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-gtk2 \
		--disable-static \
		$(use_enable doc gtk-doc) \
		$(use_enable introspection) \
		$(use_enable vala)
}

src_compile() {
	if use doc; then
		MAKEOPTS="${MAKEOPTS} -j1" gnome2_src_compile #482542
	else
		gnome2_src_compile
	fi
}

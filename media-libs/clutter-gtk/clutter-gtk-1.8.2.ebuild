# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="Library for embedding a Clutter canvas (stage) in GTK+"
HOMEPAGE="https://wiki.gnome.org/Projects/Clutter"
LICENSE="LGPL-2.1+"

SLOT="1.0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="X debug examples gtk +introspection wayland"

RDEPEND="
	>=x11-libs/gtk+-3.21.0:3[X=,introspection?,wayland=]
	>=media-libs/clutter-1.23.7:1.0[X=,gtk=,introspection?,wayland=]
	media-libs/cogl:1.0=[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-0.9.12:= )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.14
	>=sys-devel/gettext-0.18
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure \
		--disable-maintainer-flags \
		--enable-deprecated \
		$(usex debug --enable-debug=yes ' ') \
		$(use_enable introspection)
}

src_install() {
	gnome2_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/{*.c,redhand.png}
	fi
}

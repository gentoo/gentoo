# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/clutter-gtk/clutter-gtk-1.6.0.ebuild,v 1.3 2014/12/19 13:39:50 pacho Exp $

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="Library for embedding a Clutter canvas (stage) in GTK+"
HOMEPAGE="https://wiki.gnome.org/Projects/Clutter"
LICENSE="LGPL-2.1+"

SLOT="1.0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc x86"
IUSE="examples +introspection"

RDEPEND="
	>=x11-libs/gtk+-3.6.0:3[introspection?]
	>=media-libs/clutter-1.18.0:1.0[introspection?]
	media-libs/cogl:1.0=[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-0.9.12 )
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	>=sys-devel/gettext-0.18
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure \
		--disable-maintainer-flags \
		--enable-deprecated \
		$(use_enable introspection)
}

src_install() {
	gnome2_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/{*.c,redhand.png}
	fi
}

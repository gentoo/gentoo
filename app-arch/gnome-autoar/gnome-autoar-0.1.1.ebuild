# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit gnome2

DESCRIPTION="Automatic archives creating and extracting library"
HOMEPAGE="https://git.gnome.org/browse/gnome-autoar"

LICENSE="LGPL-2+ GPL-2+"
SLOT="0"
IUSE="gtk +introspection"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=app-arch/libarchive-3.2.0
	>=dev-libs/glib-2.35.6:2
	gtk? ( >=x11-libs/gtk+-3.2:3 )
	introspection? ( >=dev-libs/gobject-introspection-1.30.0:= )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.14
	gnome-base/gnome-common
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure \
		--disable-static \
		$(use_enable introspection) \
		$(use_enable gtk)
}

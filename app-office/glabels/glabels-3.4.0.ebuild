# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
inherit eutils gnome2

DESCRIPTION="Program for creating labels and business cards"
HOMEPAGE="http://www.glabels.org/"

LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE="barcode eds"

RDEPEND="
	>=dev-libs/glib-2.42.0:2
	>=x11-libs/gtk+-3.14.0:3
	>=dev-libs/libxml2-2.9.0:2
	>=gnome-base/librsvg-2.39.0:2
	>=x11-libs/cairo-1.14.0
	>=x11-libs/pango-1.36.1
	barcode? (
		>=app-text/barcode-0.98
		>=media-gfx/qrencode-3.1 )
	eds? ( >=gnome-extra/evolution-data-server-3.12.0:= )
"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/yelp-tools
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.28
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure \
		$(use_with eds libebook) \
		--disable-static
}

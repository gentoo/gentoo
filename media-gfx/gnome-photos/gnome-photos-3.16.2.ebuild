# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2 virtualx

DESCRIPTION="Access, organize and share your photos on GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Photos"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"

RDEPEND="
	>=app-misc/tracker-1:=
	>=dev-libs/glib-2.39.3:2
	gnome-base/gnome-desktop:3=
	>=gnome-base/librsvg-2.26.0
	>=dev-libs/libgdata-0.15.2:0=
	media-libs/babl
	>=media-libs/gegl-0.3:0.3
	>=media-libs/grilo-0.2.6:0.2
	>=media-plugins/grilo-plugins-0.2.6:0.2[upnp-av]
	>=media-libs/exempi-1.99.5
	media-libs/lcms:2
	>=media-libs/libexif-0.6.14
	>=net-libs/gnome-online-accounts-3.8
	>=net-libs/libgfbgraph-0.2.1:0.2
	>=x11-libs/cairo-1.14
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.15.5:3
"
DEPEND="${RDEPEND}
	dev-util/desktop-file-utils
	>=dev-util/intltool-0.50.1
	virtual/pkgconfig
	test? ( dev-util/dogtail )
"
# eautoreconf
#	app-text/yelp-tools

src_configure() {
	gnome2_src_configure \
		$(use_enable test dogtail) \
		ITSTOOL=$(type -P true)
}

src_test() {
	Xemake check
}

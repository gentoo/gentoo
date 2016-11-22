# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit gnome2

DESCRIPTION="A quick previewer for Nautilus, the GNOME file manager"
HOMEPAGE="https://git.gnome.org/browse/sushi"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="office"

# Optional app-office/unoconv support (OOo to pdf)
# freetype needed for font loader
# libX11 needed for sushi_create_foreign_window()
COMMON_DEPEND="
	>=x11-libs/gdk-pixbuf-2.23[introspection]
	>=dev-libs/gjs-1.40
	>=dev-libs/glib-2.29.14:2
	>=dev-libs/gobject-introspection-0.9.6:=
	>=media-libs/clutter-1.11.4:1.0[introspection]
	>=media-libs/clutter-gtk-1.0.1:1.0[introspection]
	>=x11-libs/gtk+-3.13.2:3[introspection]

	>=app-text/evince-3.0[introspection]
	media-libs/freetype:2
	media-libs/gstreamer:1.0[introspection]
	media-libs/gst-plugins-base:1.0[introspection]
	>=media-libs/harfbuzz-0.9.9:=
	media-libs/clutter-gst:3.0[introspection]
	media-libs/musicbrainz:5
	net-libs/webkit-gtk:4[introspection]
	x11-libs/gtksourceview:3.0[introspection]
	x11-libs/libX11

	office? ( app-office/unoconv )
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	virtual/pkgconfig
"
RDEPEND="${COMMON_DEPEND}
	>=gnome-base/nautilus-3.1.90
"

src_configure() {
	gnome2_src_configure --disable-static
}

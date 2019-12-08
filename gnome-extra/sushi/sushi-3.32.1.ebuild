# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org meson xdg

DESCRIPTION="A quick previewer for Nautilus, the GNOME file manager"
HOMEPAGE="https://git.gnome.org/browse/sushi"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="office"

# Optional app-office/libreoffice support (OOo to pdf and then preview)
# gtk+[X] optionally needed for sushi_create_foreign_window(); clutter-x11.h unconditionally included
COMMON_DEPEND="
	>=media-libs/clutter-1.11.4:1.0[X,introspection]
	media-libs/clutter-gst:3.0[introspection]
	>=media-libs/clutter-gtk-1.0.1:1.0[introspection]
	>=app-text/evince-3.0[introspection]
	media-libs/freetype:2
	>=x11-libs/gdk-pixbuf-2.23.0[introspection]
	>=dev-libs/gjs-1.40
	>=dev-libs/glib-2.29.14:2
	media-libs/gstreamer:1.0[introspection]
	media-libs/gst-plugins-base:1.0[introspection]
	>=x11-libs/gtk+-3.13.2:3[X,introspection]
	x11-libs/gtksourceview:3.0[introspection]
	>=media-libs/harfbuzz-0.9.9:=
	>=dev-libs/gobject-introspection-1.54:=
	media-libs/musicbrainz:5=
	net-libs/webkit-gtk:4[introspection]

"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"
RDEPEND="${COMMON_DEPEND}
	>=gnome-base/nautilus-3.1.90
	office? ( app-office/libreoffice )
"

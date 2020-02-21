# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2 virtualx

DESCRIPTION="A cheesy program to take pictures and videos from your webcam"
HOMEPAGE="https://wiki.gnome.org/Apps/Cheese"

LICENSE="GPL-2+"
SLOT="0/8" # subslot = libcheese soname version
IUSE="+introspection"
KEYWORDS="amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"

COMMON_DEPEND="
	>=dev-libs/glib-2.39.90:2
	>=x11-libs/gtk+-3.13.4:3[introspection?]
	>=gnome-base/gnome-desktop-2.91.6:3=
	>=media-libs/libcanberra-0.26[gtk3]
	>=media-libs/clutter-1.13.2:1.0[introspection?]
	>=media-libs/clutter-gtk-0.91.8:1.0
	media-libs/clutter-gst:3.0
	media-libs/cogl:1.0=[introspection?]

	media-video/gnome-video-effects
	x11-libs/gdk-pixbuf:2[jpeg,introspection?]
	x11-libs/libX11
	x11-libs/libXtst

	>=media-libs/gstreamer-1.4:1.0[introspection?]
	>=media-libs/gst-plugins-base-1.4:1.0[introspection?,ogg,pango,theora,vorbis,X]

	introspection? ( >=dev-libs/gobject-introspection-0.6.7:= )
"
RDEPEND="${COMMON_DEPEND}
	>=media-libs/gst-plugins-bad-1.4:1.0
	>=media-libs/gst-plugins-good-1.4:1.0

	>=media-plugins/gst-plugins-jpeg-1.4:1.0
	>=media-plugins/gst-plugins-v4l2-1.4:1.0
	>=media-plugins/gst-plugins-vpx-1.4:1.0
"
# libxml2+gdk-pixbuf required for glib-compile-resources
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.3
	dev-libs/appstream-glib
	dev-libs/libxml2:2
	dev-libs/libxslt
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.14
	>=dev-util/intltool-0.50
	dev-util/itstool
	virtual/pkgconfig
	x11-base/xorg-proto
"
# eautoreconf needs yelp-tools

src_configure() {
	gnome2_src_configure \
		GST_INSPECT=$(type -P true) \
		GTESTER_REPORT=$(type -P true) \
		VALAC=$(type -P true) \
		$(use_enable introspection) \
		--disable-lcov \
		--disable-static
}

src_test() {
	"${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/data" || die
	GSETTINGS_SCHEMA_DIR="${S}/data" virtx emake check
}

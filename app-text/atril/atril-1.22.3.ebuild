# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MATE_LA_PUNT="yes"

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

DESCRIPTION="Atril document viewer for MATE"
LICENSE="FDL-1.1+ GPL-2+ GPL-3+ LGPL-2+ LGPL-2.1+"
SLOT="0"

IUSE="caja dbus debug djvu dvi epub +introspection gnome-keyring +postscript t1lib tiff xps"

REQUIRED_USE="t1lib? ( dvi )"

RDEPEND="
	>=app-text/poppler-0.22[cairo]
	dev-libs/atk
	>=dev-libs/glib-2.50:2
	>=dev-libs/libxml2-2.5:2
	sys-libs/zlib
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22:3[introspection?]
	x11-libs/libICE
	>=x11-libs/libSM-1:0
	x11-libs/libX11
	>=x11-libs/cairo-1.9.10
	x11-libs/pango
	caja? ( >=mate-base/caja-1.17.1[introspection?] )
	djvu? ( >=app-text/djvu-3.5.17:0 )
	dvi? (
		virtual/tex-base
		t1lib? ( >=media-libs/t1lib-5:5 )
	)
	epub? (
		dev-libs/mathjax
		>=net-libs/webkit-gtk-2.4.3:4
	)
	gnome-keyring? ( >=app-crypt/libsecret-0.5 )
	introspection? ( >=dev-libs/gobject-introspection-0.6:= )
	postscript? ( >=app-text/libspectre-0.2 )
	tiff? ( >=media-libs/tiff-3.6:0 )
	xps? ( >=app-text/libgxps-0.2.1 )
	!!app-text/mate-document-viewer"

DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/rarian
	app-text/yelp-tools
	>=app-text/scrollkeeper-dtd-1:1.0
	dev-util/gdbus-codegen
	dev-util/glib-utils
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.50.1
	sys-devel/gettext
	virtual/pkgconfig"

# Tests use dogtail which is not available on Gentoo.
RESTRICT="test"

src_configure() {
	# Passing --disable-help would drop offline help, that would be inconsistent
	# with helps of the most of GNOME apps that doesn't require network for that.
	mate_src_configure \
		--disable-tests \
		--enable-comics \
		--enable-pdf \
		--enable-pixbuf \
		--enable-previewer \
		--enable-thumbnailer \
		$(use_with gnome-keyring keyring) \
		$(use_enable caja) \
		$(use_enable dbus) \
		$(use_enable debug) \
		$(use_enable djvu) \
		$(use_enable dvi) \
		$(use_enable epub) \
		$(use_enable introspection) \
		$(use_enable postscript ps) \
		$(use_enable t1lib) \
		$(use_enable tiff) \
		$(use_enable xps)
}

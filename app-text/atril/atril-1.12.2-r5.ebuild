# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MATE_LA_PUNT="yes"

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~arm x86"
fi

DESCRIPTION="Atril document viewer for MATE"
LICENSE="GPL-2"
SLOT="0"

IUSE="caja dbus debug djvu dvi epub +introspection gnome-keyring gtk3 +postscript t1lib tiff xps"

REQUIRED_USE="t1lib? ( dvi )
	!gtk3? ( !epub )" #608604

RDEPEND=">=app-text/poppler-0.16:0=[cairo]
	app-text/rarian:0
	dev-libs/atk:0
	>=dev-libs/glib-2.36:2
	>=dev-libs/libxml2-2.5:2
	>=mate-base/mate-desktop-1.9[gtk3(-)=]
	sys-libs/zlib:0
	x11-libs/gdk-pixbuf:2
	x11-libs/libICE:0
	>=x11-libs/libSM-1:0
	x11-libs/libX11:0
	>=x11-libs/cairo-1.9.10:0
	x11-libs/pango:0
	caja? ( >=mate-base/caja-1.8[gtk3(-)=,introspection?] )
	djvu? ( >=app-text/djvu-3.5.17:0 )
	dvi? (
		virtual/tex-base:0
		t1lib? ( >=media-libs/t1lib-5:5 )
	)
	epub? ( dev-libs/mathjax )
	gnome-keyring? ( >=app-crypt/libsecret-0.5:0 )
	!gtk3? (
		>=x11-libs/gtk+-2.24.0:2[introspection?]
	)
	gtk3? (
		>=x11-libs/gtk+-3.0:3[introspection?]
		epub? ( >=net-libs/webkit-gtk-2.4.3:4 )
	)
	introspection? ( >=dev-libs/gobject-introspection-0.6:= )
	postscript? ( >=app-text/libspectre-0.2:0 )
	tiff? ( >=media-libs/tiff-3.6:0 )
	xps? ( >=app-text/libgxps-0.2.0:0 )
	!!app-text/mate-document-viewer"

DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/yelp-tools:0
	>=app-text/scrollkeeper-dtd-1:1.0
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.50.1:*
	virtual/pkgconfig:*
	sys-devel/gettext:*"

# Tests use dogtail which is not available on Gentoo.
RESTRICT="test"

FILES=( "${FILESDIR}/${PN}-cve-2017-1000083.patch" )

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
		--with-matedesktop \
		--with-gtk=$(usex gtk3 3.0 2.0) \
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

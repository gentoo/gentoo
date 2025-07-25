# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MATE_LA_PUNT="yes"
PYTHON_COMPAT=( python3_{11..13} )
inherit mate python-any-r1 virtualx

DESCRIPTION="Atril document viewer for MATE"

LICENSE="FDL-1.1+ GPL-2+ GPL-3+ LGPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~loong ~riscv x86"
IUSE="caja dbus debug djvu dvi epub +introspection keyring nls +postscript synctex t1lib test tiff xps"

REQUIRED_USE="t1lib? ( dvi )"

DEPEND="
	app-accessibility/at-spi2-core:2
	app-text/poppler[cairo]
	dev-libs/glib:2
	dev-libs/libxml2:2=
	>=mate-base/mate-desktop-$(ver_cut 1-2)
	sys-libs/zlib
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3[introspection?]
	x11-libs/libICE
	x11-libs/libSM:0
	x11-libs/libX11
	x11-libs/cairo
	x11-libs/pango
	caja? ( mate-base/caja[introspection?] )
	djvu? ( app-text/djvu:0 )
	dvi? (
		virtual/tex-base
		t1lib? ( media-libs/t1lib:5 )
	)
	epub? (
		<dev-libs/mathjax-3
		net-libs/webkit-gtk:4.1
	)
	keyring? ( app-crypt/libsecret )
	introspection? ( dev-libs/gobject-introspection:= )
	postscript? ( app-text/libspectre )
	synctex? ( virtual/tex-base )
	tiff? ( media-libs/tiff:= )
	xps? ( app-text/libgxps )
"

RDEPEND="${DEPEND}
	gnome-base/gvfs
	virtual/libintl
"

BDEPEND="
	app-text/docbook-xml-dtd:4.1.2
	app-text/yelp-tools
	dev-util/gdbus-codegen
	dev-util/glib-utils
	dev-util/gtk-doc
	dev-build/gtk-doc-am
	sys-devel/gettext
	virtual/pkgconfig
	test? ( $(python_gen_any_dep 'dev-util/dogtail[${PYTHON_USEDEP}]') )
"

#RESTRICT="!test? ( test )"
# Tests use dogtail and require using accessibility services.
# Until we figure out how to run successfully, don't run tests
RESTRICT="test"

python_check_deps() {
	use test && python_has_version "dev-util/dogtail[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	# Passing --disable-help would drop offline help, that would be inconsistent
	# with helps of the most of GNOME apps that doesn't require network for that.
	mate_src_configure \
		--enable-comics \
		--enable-pdf \
		--enable-pixbuf \
		--enable-previewer \
		--enable-thumbnailer \
		$(use_with keyring) \
		$(use_enable caja) \
		$(use_enable dbus) \
		$(use_enable debug) \
		$(use_enable djvu) \
		$(use_enable dvi) \
		$(use_enable epub) \
		$(use_enable introspection) \
		$(use_enable nls) \
		$(use_enable postscript ps) \
		$(use_enable synctex) \
		$(use_enable t1lib) \
		$(use_enable test tests) \
		$(use_enable tiff) \
		$(use_enable xps)
}

src_test() {
	export GSETTINGS_BACKEND=keyfile
	gsettings set org.gnome.desktop.interface toolkit-accessibility true || die
	gsettings set org.mate.interface accessibility true || die
	virtx emake check
}

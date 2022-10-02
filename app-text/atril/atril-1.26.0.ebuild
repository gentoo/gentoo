# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MATE_LA_PUNT="yes"

PYTHON_COMPAT=( python3_{8..10} )

inherit mate python-any-r1 virtualx

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"
fi

DESCRIPTION="Atril document viewer for MATE"
LICENSE="FDL-1.1+ GPL-2+ GPL-3+ LGPL-2+ LGPL-2.1+"
SLOT="0"

IUSE="caja dbus debug djvu dvi epub +introspection gnome-keyring nls +postscript synctex t1lib test tiff xps"

REQUIRED_USE="t1lib? ( dvi )"

COMMON_DEPEND="
	>=app-text/poppler-0.22[cairo]
	dev-libs/atk
	>=dev-libs/glib-2.62:2
	>=dev-libs/libxml2-2.5:2
	sys-libs/zlib
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22:3[introspection?]
	x11-libs/libICE
	>=x11-libs/libSM-1:0
	x11-libs/libX11
	>=x11-libs/cairo-1.14
	x11-libs/pango
	caja? ( >=mate-base/caja-1.17.1[introspection?] )
	djvu? ( >=app-text/djvu-3.5.17:0 )
	dvi? (
		virtual/tex-base
		t1lib? ( >=media-libs/t1lib-5:5 )
	)
	epub? (
		dev-libs/mathjax
		>=net-libs/webkit-gtk-2.6.0:4
	)
	gnome-keyring? ( >=app-crypt/libsecret-0.5 )
	introspection? ( >=dev-libs/gobject-introspection-0.6:= )
	postscript? ( >=app-text/libspectre-0.2 )
	synctex? ( virtual/tex-base )
	tiff? ( >=media-libs/tiff-3.6:0 )
	xps? ( >=app-text/libgxps-0.2.1 )
"

RDEPEND="${COMMON_DEPEND}
	virtual/libintl
	!!app-text/mate-document-viewer
"

BDEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/rarian
	app-text/yelp-tools
	>=app-text/scrollkeeper-dtd-1:1.0
	dev-util/gdbus-codegen
	dev-util/glib-utils
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	>=sys-devel/gettext-0.19.8
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
	local use_ps;
	if use postscript ; then
		use_ps="--enable-ps"
	else
		use_ps="--disable-ps"
	fi
	mate_src_configure \
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
		$(use_enable nls) \
		$(use_enable synctex) \
		$(use_enable t1lib) \
		$(use_enable test tests) \
		$(use_enable tiff) \
		$(use_enable xps) \
		${use_ps}
}

src_test() {
	export GSETTINGS_BACKEND=keyfile
	gsettings set org.gnome.desktop.interface toolkit-accessibility true || die
	gsettings set org.mate.interface accessibility true || die
	virtx emake check
}

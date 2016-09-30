# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
VALA_USE_DEPEND="vapigen"

inherit gnome2 vala

DESCRIPTION="Integrated LaTeX environment for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/LaTeXila"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+introspection +latexmk rubber"

# gspell-0.1 is required for this cycle
# https://git.gnome.org/browse/latexila/commit/?h=gnome-3-18&id=fd6b77796e304cfb9e31844cf24432d3b2cb6043
COMMON_DEPEND="$(vala_depend)
	app-text/enchant
	>=app-text/gspell-1.0:0=
	>=dev-libs/glib-2.40:2[dbus]
	>=dev-libs/libgee-0.10:0.8=
	gnome-base/gsettings-desktop-schemas
	>=x11-libs/gtk+-3.20:3
	>=x11-libs/gtksourceview-3.18:3.0=
	x11-libs/gdk-pixbuf:2
	x11-libs/libX11
	x11-libs/pango
	introspection? ( >=dev-libs/gobject-introspection-1.30.0:= )
"
RDEPEND="${COMMON_DEPEND}
	virtual/latex-base
	x11-themes/hicolor-icon-theme
	latexmk? ( dev-tex/latexmk )
	rubber? ( dev-tex/rubber )
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/gtk-doc-am-1.14
	>=dev-util/intltool-0.50.1
	dev-util/itstool
	virtual/pkgconfig
"

src_prepare() {
	gnome2_src_prepare
	vala_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable introspection)
}

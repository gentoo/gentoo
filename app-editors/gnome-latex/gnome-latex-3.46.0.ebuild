# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2

DESCRIPTION="Integrated LaTeX environment for GNOME"
HOMEPAGE="https://gitlab.gnome.org/swilmet/gnome-latex"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="+introspection +latexmk rubber"

DEPEND="
	>=dev-libs/glib-2.70:2
	>=x11-libs/gtk+-3.22:3
	>=app-text/gspell-1.8:0=
	>=gui-libs/libgedit-amtk-5:=
	>=gui-libs/tepl-6.8:=
	>=dev-libs/libgee-0.10:0.8=
	gnome-base/gsettings-desktop-schemas
	x11-libs/gdk-pixbuf:2
	x11-libs/pango
	introspection? ( >=dev-libs/gobject-introspection-1.30.0:= )
	gnome-base/dconf
"
RDEPEND="${DEPEND}
	virtual/latex-base
	x11-themes/hicolor-icon-theme
	latexmk? ( dev-tex/latexmk )
	rubber? ( dev-tex/rubber )
"
BDEPEND="
	dev-util/gdbus-codegen
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.14
	dev-util/itstool
	>=sys-devel/gettext-0.19.6:0
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure \
		$(use_enable introspection) \
		--enable-dconf_migration
}

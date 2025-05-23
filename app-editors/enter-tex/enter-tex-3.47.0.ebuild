# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="Integrated LaTeX environment for GNOME"
HOMEPAGE="https://gitlab.gnome.org/swilmet/enter-tex"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="gtk-doc test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/glib-2.80:2
	>=x11-libs/gtk+-3.22:3
	>=app-text/gspell-1.8:0=
	>=gui-libs/libgedit-tepl-6.11:=
	>=dev-libs/libgee-0.10:0.8=
	gnome-base/gsettings-desktop-schemas
	x11-libs/gdk-pixbuf:2
	x11-libs/pango
	gnome-base/dconf
"
#	introspection? ( >=dev-libs/gobject-introspection-1.30.0:= )
RDEPEND="${DEPEND}
	virtual/latex-base
	>=dev-tex/latexmk-4.31
	x11-themes/hicolor-icon-theme
"
BDEPEND="
	$(vala_depend)
	dev-util/gdbus-codegen
	dev-util/glib-utils
	gtk-doc? ( >=dev-util/gtk-doc-1.17 )
	dev-util/itstool
	>=sys-devel/gettext-0.19.6:0
	virtual/pkgconfig
"

src_prepare() {
	vala_setup
	default
}

src_configure() {
	local emesonargs=(
		-Ddconf_migration=true
		$(meson_use gtk-doc gtk_doc)
		$(meson_use test tests)
	)
	meson_src_configure
}

src_compile() {
	# There is an upstream bug with meson to build gtex,
	# https://gitlab.gnome.org/swilmet/enter-tex/-/issues/19
	# https://gitlab.gnome.org/swilmet/enter-tex/-/blob/main/docs/more-information.md
	meson_src_compile src/gtex/Gtex-1.gir
	meson_src_compile
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}

# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils meson vala xdg

# prepared for rename
MY_PN="enter-tex"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="TeX/LaTeX text editor"
HOMEPAGE="https://gitlab.gnome.org/World/gedit/enter-tex"
SRC_URI="https://gitlab.gnome.org/World/gedit/${MY_PN}/-/archive/${PV}/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

IUSE="gtk-doc +latexmk test"
RESTRICT="!test? ( test )"

# https://gitlab.gnome.org/World/gedit/enter-tex/-/blob/main/docs/more-information.md#dependencies
DEPEND="
	>=dev-libs/glib-2.80:2[introspection]
	>=app-text/gspell-1.8:=[introspection]
	>=dev-libs/libgee-0.10:0.8=[introspection]
	gnome-base/dconf
	gnome-base/gsettings-desktop-schemas
	gui-libs/libgedit-amtk:5
	gui-libs/libgedit-gtksourceview:300
	>=gui-libs/libgedit-tepl-6.14.0:6=
	>=x11-libs/gtk+-3.22:3[introspection]

"
RDEPEND="${DEPEND}
	virtual/latex-base
	x11-themes/hicolor-icon-theme
	latexmk? ( >=dev-tex/latexmk-4.31 )
"
BDEPEND="
	$(vala_depend)
	>=dev-util/gdbus-codegen-2.80
	dev-util/glib-utils
	dev-util/itstool
	dev-libs/gobject-introspection
	sys-devel/gettext
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
"

src_configure() {
	vala_setup

	local emesonargs=(
		-Ddconf_migration=true
		$(meson_use gtk-doc gtk_doc)
		$(meson_use test tests)
	)

	meson_src_configure
}

src_compile() {
	# https://gitlab.gnome.org/World/gedit/enter-tex/-/blob/main/docs/more-information.md#install-procedure
	meson_src_compile src/gtex/Gtex-1.gir
	meson_src_compile
}

pkg_preinst() {
	xdg_pkg_preinst
	gnome2_schemas_savelist
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org meson virtualx

DESCRIPTION="GtkSourceView-based text editors and IDE helper library"
HOMEPAGE="https://wiki.gnome.org/Projects/Tepl"

LICENSE="LGPL-3+"
SLOT="5"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~sparc x86"
IUSE="gtk-doc"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.64:2
	>=x11-libs/gtk+-3.22:3[introspection]
	>=x11-libs/gtksourceview-4.0:4[introspection]
	>=gui-libs/amtk-5.0:5[introspection]
	dev-libs/icu:=
	>=dev-libs/gobject-introspection-1.42:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	gtk-doc? ( >=dev-util/gtk-doc-1.25
		app-text/docbook-xml-dtd:4.3
	)
	>=sys-devel/gettext-0.19.6
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc gtk_doc)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}

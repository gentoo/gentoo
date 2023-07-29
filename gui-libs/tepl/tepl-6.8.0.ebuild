# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson virtualx

DESCRIPTION="GtkSourceView-based text editors and IDE helper library"
HOMEPAGE="https://gitlab.gnome.org/swilmet/tepl"

LICENSE="LGPL-3+"
SLOT="6/4"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="gtk-doc"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.74:2
	>=x11-libs/gtk+-3.22:3
	>=gui-libs/libgedit-gtksourceview-299.0.4:300
	>=gui-libs/libgedit-amtk-5.0:5=
	dev-libs/icu:=
	gnome-base/gsettings-desktop-schemas

	dev-libs/gobject-introspection:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	gtk-doc? (
		>=dev-util/gtk-doc-1.25
		app-text/docbook-xml-dtd:4.3
	)
	>=sys-devel/gettext-0.19.6
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Dgobject_introspection=true
		$(meson_use gtk-doc gtk_doc)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}

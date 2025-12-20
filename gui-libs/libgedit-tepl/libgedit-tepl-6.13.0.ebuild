# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson virtualx

DESCRIPTION="GtkSourceView-based text editors and IDE helper library"
HOMEPAGE="https://gitlab.gnome.org/World/gedit/libgedit-tepl"
SRC_URI="https://gitlab.gnome.org/World/gedit/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="LGPL-3+"
SLOT="6/4"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"
IUSE="gtk-doc"
RESTRICT="!test? ( test )"

RDEPEND="
	!gui-libs/tepl
	>=dev-libs/glib-2.74:2
	>=x11-libs/gtk+-3.22:3[introspection]
	>=gui-libs/libgedit-gtksourceview-299.5.0:300
	>=gui-libs/libgedit-amtk-5.9:5=[introspection]
	>=gui-libs/libgedit-gfls-0.3
	dev-libs/icu:=
	>=gnome-base/gsettings-desktop-schemas-42
	>=gui-libs/libhandy-1.6:1
	>=dev-libs/gobject-introspection-1.82.0-r2:=
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
		$(meson_use test tests)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}

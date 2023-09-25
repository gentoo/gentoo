# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_USE_DEPEND="vapigen"

inherit gnome.org meson vala

DESCRIPTION="Thin GObject wrapper around the libcanberra sound event library"
HOMEPAGE="https://wiki.gnome.org/Projects/GSound"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv x86"
IUSE="gtk-doc +introspection +vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.36:2
	media-libs/libcanberra
	introspection? ( >=dev-libs/gobject-introspection-1.2.9:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.3 )
	vala? ( $(vala_depend) )
"

src_prepare() {
	use vala && vala_src_prepare
	default
}

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc gtk_doc)
		$(meson_use introspection)
		$(meson_use vala enable_vala)
	)
	meson_src_configure
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org meson xdg vala

DESCRIPTION="JSON-RPC library for GLib"
HOMEPAGE="https://gitlab.gnome.org/GNOME/jsonrpc-glib"

LICENSE="LGPL-2.1+"
SLOT="0/1"
KEYWORDS="amd64 x86"

IUSE="gtk-doc +introspection test vala"
REQUIRED_USE="vala? ( introspection )"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/glib:2
	dev-libs/json-glib[introspection?]
	introspection? ( dev-libs/gobject-introspection:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	vala? ( $(vala_depend) )
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
"

src_prepare() {
	use vala && vala_src_prepare
	xdg_src_prepare
}

src_configure() {
	local emesonargs=(
		-Denable_profiling=false # -pg passing
		$(meson_use introspection with_introspection)
		$(meson_use vala with_vapi)
		$(meson_use gtk-doc enable_gtk_doc)
		$(meson_use test enable_tests)
	)
	meson_src_configure
}

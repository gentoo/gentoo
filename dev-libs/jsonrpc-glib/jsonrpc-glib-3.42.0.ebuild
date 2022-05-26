# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson vala

DESCRIPTION="JSON-RPC library for GLib"
HOMEPAGE="https://gitlab.gnome.org/GNOME/jsonrpc-glib"

LICENSE="LGPL-2.1+"
SLOT="0/1"
KEYWORDS="~amd64 ~x86"

IUSE="gtk-doc +introspection test vala"
REQUIRED_USE="
	gtk-doc? ( introspection )
	vala? ( introspection )
"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/glib:2
	dev-libs/json-glib[introspection?]
	introspection? ( dev-libs/gobject-introspection:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	vala? ( $(vala_depend) )
	dev-util/glib-utils
	virtual/pkgconfig
	gtk-doc? ( dev-util/gi-docgen )
"

src_prepare() {
	default
	use vala && vala_setup
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

src_install() {
	meson_src_install

	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/html/ || die
		mv "${ED}"/usr/share/doc/${PN} "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson vala

DESCRIPTION="Templating library for GLib"
HOMEPAGE="https://gitlab.gnome.org/GNOME/template-glib"

LICENSE="LGPL-2.1+"
SLOT="0/1"
KEYWORDS="~amd64 ~arm64 ~x86"

IUSE="gtk-doc +introspection test vala"
RESTRICT="!test? ( test )"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	dev-libs/glib:2
	dev-libs/gobject-introspection:=
" # depends on go-i unconditionally for own functionality, USE flag controls GIR/typelib generation
DEPEND="${RDEPEND}"
BDEPEND="
	vala? ( $(vala_depend) )
	dev-util/glib-utils
	app-alternatives/yacc
	app-alternatives/lex
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
"

src_prepare() {
	default
	use vala && vala_setup
}

src_configure() {
	local emesonargs=(
		-Dtracing=false # extra trace debugging that would make things slower
		-Dprofiling=false # -pg passing
		$(meson_feature introspection)
		$(meson_use vala vapi)
		$(meson_use gtk-doc gtk_doc)
		$(meson_use test tests)
	)
	meson_src_configure
}

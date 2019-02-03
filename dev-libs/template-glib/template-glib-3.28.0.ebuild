# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome.org meson xdg vala

DESCRIPTION="Templating library for GLib"
HOMEPAGE="https://gitlab.gnome.org/GNOME/template-glib"

LICENSE="LGPL-2.1+"
SLOT="0/1"
KEYWORDS="~amd64 ~x86"

IUSE="gtk-doc +introspection vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	dev-libs/glib:2
	dev-libs/gobject-introspection:=
" # 3.28.0 depends on go-i unconditionally, USE flag controls GIR/typelib generation
DEPEND="${RDEPEND}
	vala? ( $(vala_depend) )
	dev-util/glib-utils
	sys-devel/bison
	sys-devel/flex
	sys-devel/gettext
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
"

src_prepare() {
	use vala && vala_src_prepare
	xdg_src_prepare
}

src_configure() {
	local emesonargs=(
		-Denable_tracing=false # extra trace debugging that would make things slower
		-Denable_profiling=false # -pg passing
		$(meson_use introspection with_introspection)
		$(meson_use vala with_vapi)
		$(meson_use gtk-doc enable_gtk_doc)
	)
	meson_src_configure
}

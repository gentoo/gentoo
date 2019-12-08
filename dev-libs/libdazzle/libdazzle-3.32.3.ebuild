# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org meson xdg vala virtualx

DESCRIPTION="Experimental new features for GTK+ and GLib"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libdazzle"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc x86"

IUSE="gtk-doc +introspection test +vala"
REQUIRED_USE="vala? ( introspection )"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.56.0:2
	>=x11-libs/gtk+-3.24.0:3[introspection?]
	introspection? ( dev-libs/gobject-introspection:= )
"
DEPEND="${RDEPEND}"
# libxml2 required for glib-compile-resources; glib-utils for glib-mkenums
BDEPEND="
	>=dev-util/meson-0.49.0
	vala? ( $(vala_depend) )
	dev-libs/libxml2:2
	dev-util/glib-utils
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
		# On linux it'll always use a vdso based implementation that is even faster
		# than rdtscp insn, thus never build with rdtscp until we don't support non-linux
		# as the rdtscp using function will never get called anyways.
		-Denable_rdtscp=false
		-Denable_tools=true # /usr/bin/dazzle-list-counters
		$(meson_use introspection with_introspection)
		$(meson_use vala with_vapi)
		$(meson_use gtk-doc enable_gtk_doc)
		$(meson_use test enable_tests)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}

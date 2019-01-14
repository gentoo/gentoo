# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome.org meson xdg vala virtualx

DESCRIPTION="Experimental new features for GTK+ and GLib"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libdazzle"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 ~sparc x86"

IUSE="gtk-doc +introspection test vala"
REQUIRED_USE="vala? ( introspection )"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.56.0:2
	>=x11-libs/gtk+-3.24.0:3[introspection?]
	introspection? ( dev-libs/gobject-introspection:= )
"
# libxml2 required for glib-compile-resources; glib-utils for glib-mkenums
DEPEND="${RDEPEND}
	vala? ( $(vala_depend) )
	dev-libs/libxml2:2
	dev-util/glib-utils
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
"

PATCHES=(
	"${FILESDIR}"/${PV}-leak-fix.patch # from libdazzle-3-30 branch
)

src_prepare() {
	use vala && vala_src_prepare
	xdg_src_prepare
}

src_configure() {
	local emesonargs=(
		-Denable_tracing=false # extra trace debugging that would make things slower
		-Denable_profiling=false # -pg passing
		# -Denable_rdtscp=false # TODO: CPU_FLAGS_X86 for it?
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

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_USE_DEPEND="vapigen"

inherit gnome.org meson vala

DESCRIPTION="Library providing DLNA-related functionality for MediaServers"
HOMEPAGE="https://wiki.gnome.org/Projects/GUPnP https://gitlab.gnome.org/GNOME/gupnp-dlna"

LICENSE="LGPL-2"
SLOT="2.0/4" # subslot: soname version
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="gtk-doc +introspection"

RDEPEND="
	>=dev-libs/glib-2.34:2
	>=dev-libs/libxml2-2.5:2
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-0.6.4:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
	introspection? ( $(vala_depend) )
"

src_prepare() {
	use introspection && vala_src_prepare
	default
}

src_configure() {
	local emesonargs=(
		-Dgstreamer_backend=enabled
		-Ddefault_backend=gstreamer
		$(meson_use introspection)
		$(meson_use introspection vapi)
		$(meson_use gtk-doc gtk_doc)
	)
	meson_src_configure
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_USE_DEPEND="vapigen"

inherit gnome.org meson vala

DESCRIPTION="Utility library aiming to ease the handling UPnP A/V profiles"
HOMEPAGE="https://wiki.gnome.org/Projects/GUPnP https://gitlab.gnome.org/GNOME/gupnp-av"

LICENSE="LGPL-2"
SLOT="0/3" # subslot: soname version
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="gtk-doc +introspection"

RDEPEND="
	>=dev-libs/glib-2.58:2
	>=net-libs/libsoup-2.28.2:2.4[introspection?]
	dev-libs/libxml2
	introspection? ( >=dev-libs/gobject-introspection-1.36:= )
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
		$(meson_use introspection)
		$(meson_use introspection vapi)
		$(meson_use gtk-doc gtk_doc)
	)
	meson_src_configure
}

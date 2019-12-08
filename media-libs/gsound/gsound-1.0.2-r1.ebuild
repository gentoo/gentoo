# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit gnome2 vala

DESCRIPTION="Thin GObject wrapper around the libcanberra sound event library"
HOMEPAGE="https://wiki.gnome.org/Projects/GSound"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc ~ppc64 x86"
IUSE="+introspection +vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.36:2
	media-libs/libcanberra
	introspection? ( >=dev-libs/gobject-introspection-1.2.9:= )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.20
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

src_prepare() {
	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure () {
	gnome2_src_configure \
		--disable-static \
		$(use_enable introspection) \
		$(use_enable vala)
}

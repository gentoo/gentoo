# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_USE_DEPEND="vapigen"

inherit gnome.org meson vala xdg

DESCRIPTION="Clutter based world map renderer"
HOMEPAGE="https://wiki.gnome.org/Projects/libchamplain"

SLOT="0.12"
LICENSE="LGPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

IUSE="+gtk gtk-doc +introspection vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	dev-db/sqlite:3
	>=dev-libs/glib-2.38:2
	>=media-libs/clutter-1.24:1.0[introspection?]
	media-libs/cogl:=
	>=net-libs/libsoup-2.42:2.4
	>=x11-libs/cairo-1.4
	x11-libs/gtk+:3
	gtk? (
		x11-libs/gtk+:3[introspection?]
		media-libs/clutter-gtk:1.0 )
	introspection? ( dev-libs/gobject-introspection:= )
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	virtual/pkgconfig
	gtk-doc? ( >=dev-util/gtk-doc-1.15 )
	vala? ( $(vala_depend) )
"

src_prepare() {
	use vala && vala_src_prepare
	xdg_src_prepare
}

src_configure() {
	# demos are only built, so just disable them
	meson_src_configure \
		-Dmemphis=false \
		-Ddemos=false \
		$(meson_use gtk widgetry) \
		$(meson_use gtk-doc gtk_doc) \
		$(meson_use introspection) \
		$(meson_use vala vapi)
}

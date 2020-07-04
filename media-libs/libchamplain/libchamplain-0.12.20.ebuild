# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_USE_DEPEND="vapigen"

inherit gnome.org meson vala xdg

DESCRIPTION="Clutter based world map renderer"
HOMEPAGE="https://wiki.gnome.org/Projects/libchamplain"

SLOT="0.12"
LICENSE="LGPL-2.1+"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"

IUSE="+gtk gtk-doc +introspection vala"
REQUIRED_USE="
	vala? ( introspection )
	gtk-doc? ( gtk )
" # gtk-doc build gets disabled in meson if gtk widgetry is disabled (no separate libchamplain-gtk gtk-docs anymore)

RDEPEND="
	>=dev-libs/glib-2.38:2
	>=x11-libs/gtk+-3.0:3
	>=media-libs/clutter-1.24:1.0[introspection?]
	gtk? (
		x11-libs/gtk+:3[introspection?]
		media-libs/clutter-gtk:1.0 )
	>=x11-libs/cairo-1.4
	dev-db/sqlite:3
	>=net-libs/libsoup-2.42:2.4
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
	media-libs/cogl:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	>=dev-util/meson-0.49.0
	virtual/pkgconfig
	gtk-doc? ( >=dev-util/gtk-doc-1.15 )
	vala? ( $(vala_depend) )
"

src_prepare() {
	xdg_src_prepare
	use vala && vala_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dmemphis=false # TODO: What's the state of this vector renderer?
		$(meson_use introspection)
		$(meson_use vala vapi)
		$(meson_use gtk widgetry)
		$(meson_use gtk-doc gtk_doc)
		-Ddemos=false # only built, not installed
	)
	meson_src_configure
}

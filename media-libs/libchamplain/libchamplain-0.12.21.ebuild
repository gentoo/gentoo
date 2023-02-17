# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson vala xdg

DESCRIPTION="Clutter based world map renderer"
HOMEPAGE="https://wiki.gnome.org/Projects/libchamplain"

SLOT="0.12"
LICENSE="LGPL-2.1+"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc ppc64 ~riscv ~sparc x86"

IUSE="+gtk gtk-doc +introspection vala"
REQUIRED_USE="
	vala? ( introspection )
	gtk-doc? ( gtk )
" # gtk-doc build gets disabled in meson if gtk widgetry is disabled (no separate libchamplain-gtk gtk-docs anymore)

RDEPEND="
	>=dev-libs/glib-2.68:2
	>=x11-libs/gtk+-3.0:3
	>=media-libs/clutter-1.24:1.0[introspection?]
	gtk? (
		x11-libs/gtk+:3[introspection?]
		media-libs/clutter-gtk:1.0
	)
	>=x11-libs/cairo-1.4
	dev-db/sqlite:3
	>=net-libs/libsoup-3:3.0
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
	media-libs/cogl:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	virtual/pkgconfig
	gtk-doc? (
		>=dev-util/gtk-doc-1.15
		app-text/docbook-xml-dtd:4.1.2
	)
	vala? ( $(vala_depend) )
"

src_prepare() {
	default
	xdg_environment_reset
	use vala && vala_setup
}

src_configure() {
	local emesonargs=(
		-Dmemphis=false # TODO: What's the state of this vector renderer?
		$(meson_use introspection)
		-Dlibsoup3=true
		$(meson_use vala vapi)
		$(meson_use gtk widgetry)
		$(meson_use gtk-doc gtk_doc)
		-Ddemos=false # only built, not installed
	)
	meson_src_configure
}

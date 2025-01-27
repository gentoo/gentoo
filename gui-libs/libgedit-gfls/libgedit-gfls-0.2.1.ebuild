# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson virtualx

DESCRIPTION="A module dedicated to file loading and saving"
HOMEPAGE="https://gitlab.gnome.org/World/gedit/libgedit-gfls"

LICENSE="LGPL-3+"
SLOT="6/4"
KEYWORDS="~amd64 ~loong ~riscv"
IUSE="gtk-doc"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.78:2
	>=x11-libs/gtk+-3.22:3[introspection]
	gnome-base/gsettings-desktop-schemas
	dev-libs/gobject-introspection:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	gtk-doc? (
		>=dev-util/gtk-doc-1.25
		app-text/docbook-xml-dtd:4.3
	)
	>=sys-devel/gettext-0.19.6
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Dgobject_introspection=true
		$(meson_use gtk-doc gtk_doc)
		$(meson_use test tests)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}

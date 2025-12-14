# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="A documentation viewer for the GNOME ecosystem"
HOMEPAGE="https://apps.gnome.org/Manuals/ https://gitlab.gnome.org/GNOME/manuals"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="clang doc +d-spy flatpak +git gtk-doc spell +sysprof test +webkit"
REQUIRED_USE="
	flatpak? ( git )
"

RDEPEND="
	>=dev-libs/glib-2.78:2
	>=gui-libs/gtk-4.14:4[introspection]
	>=gui-libs/libadwaita-1.7.0:1
	>=gui-libs/libpanel-1.6.0:1
	>=dev-libs/libdex-0.4:=
	>=dev-libs/gom-0.4:=
	webkit? ( >=net-libs/webkit-gtk-2.42.0:6=[introspection] )
	flatpak? (
		dev-util/ostree
		>=net-libs/libsoup-3:3.0
		>=sys-apps/flatpak-1.10.2
	)

	>=dev-libs/gobject-introspection-1.74.0:=
"
DEPEND="${RDEPEND}"

BDEPEND="
	gtk-doc? (
		dev-util/gi-docgen
		app-text/docbook-xml-dtd:4.3
	)
	test? (
		dev-libs/appstream-glib
		sys-apps/dbus
	)
	dev-util/desktop-file-utils
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Ddevelopment=false
	)
	meson_src_configure
}

src_install() {
	meson_src_install
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}

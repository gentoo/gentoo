# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic gnome.org gnome2-utils meson xdg

DESCRIPTION="A terminal for a container-oriented desktop"
HOMEPAGE="https://gitlab.gnome.org/chergert/ptyxis"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64"
IUSE="X test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.80:2
	>=gui-libs/gtk-4.12.2:4[X?]
	>=gui-libs/libadwaita-1.6:1
	>=gui-libs/vte-0.78.0:2.91-gtk4
	dev-libs/libportal[gtk]
	gnome-base/libgtop:2=
	>=dev-libs/libpcre2-10.32:0=
	gnome-base/gsettings-desktop-schemas

	x11-libs/pango[X?]
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? (
		dev-util/desktop-file-utils
		dev-libs/appstream-glib
	)
"

src_configure() {
	use X || append-cppflags -DGENTOO_GTK_HIDE_X11

	local emesonargs=(
		-Ddevelopment=false
		-Dgeneric=terminal
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}

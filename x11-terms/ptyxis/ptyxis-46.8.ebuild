# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="A terminal for a container-oriented desktop"
HOMEPAGE="https://gitlab.gnome.org/chergert/ptyxis"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.80:2
	>=gui-libs/gtk-4.12.2:4
	>=gui-libs/libadwaita-1.4_alpha:1
	>=gui-libs/vte-0.75.0:2.91-gtk4[-vanilla]
	gnome-base/libgtop:2=
	>=dev-libs/libpcre2-10.32:0=
	gnome-base/gsettings-desktop-schemas

	x11-libs/pango
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

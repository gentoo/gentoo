# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="A simple user-friendly terminal emulator for the GNOME desktop"
HOMEPAGE="https://gitlab.gnome.org/GNOME/console"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.72:2
	>=gui-libs/gtk-4.6:4
	>=gui-libs/libadwaita-1.2:1
	>=gui-libs/vte-0.70.0:2.91-gtk4
	gnome-base/libgtop:2=
	>=dev-libs/libpcre2-10.32:0=
	gnome-base/gsettings-desktop-schemas

	x11-libs/pango
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local emesonargs=(
		-Ddevel=false
		$(meson_use test tests)
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

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="Tecla is a keyboard layout viewer"
HOMEPAGE="https://gitlab.gnome.org/GNOME/tecla"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	gui-libs/gtk:4[introspection]
	>=gui-libs/libadwaita-1.4_alpha:1
	x11-libs/libxkbcommon
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/glib
	sys-devel/gettext
	virtual/pkgconfig
"

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}

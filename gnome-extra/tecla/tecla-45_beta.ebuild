# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="Tecla is a keyboard layout viewer"
HOMEPAGE="https://gitlab.gnome.org/GNOME/tecla"

LICENSE="GPL-2+ BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="
	>=gui-libs/gtk-4.6:4[introspection]
	>=gui-libs/libadwaita-1.4_alpha:1=
	dev-python/xkbcommon
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
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

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson optfeature vala xdg

DESCRIPTION="Play the classic two-player boardgame of chess"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-chess"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"

RDEPEND="
	>=dev-libs/glib-2.44:2
	>=gui-libs/gtk-4.14:4
	>=gui-libs/libadwaita-1.5:1
	>=gnome-base/librsvg-2.46.0:2
	x11-libs/pango
"
DEPEND="${RDEPEND}
	gnome-base/librsvg:2[vala]
"
BDEPEND="
	${PYTHON_DEPS}
	$(vala_depend)
	dev-util/itstool
	dev-libs/appstream-glib
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_prepare() {
	default
	vala_setup
	xdg_environment_reset
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
	optfeature "playing against the computer" games-board/gnuchess
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}

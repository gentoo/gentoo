# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson readme.gentoo-r1 vala xdg

DESCRIPTION="Play the classic two-player boardgame of chess"
HOMEPAGE="https://wiki.gnome.org/Apps/Chess https://gitlab.gnome.org/GNOME/gnome-chess"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

RDEPEND="
	>=dev-libs/glib-2.44:2
	gui-libs/gtk:4
	>=gui-libs/libadwaita-1.0.0:1
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

DOC_CONTENTS="To be able to play against a computer you will need
to install a chess engine package, for example games-board/gnuchess"

src_prepare() {
	default
	vala_setup
	xdg_environment_reset
}

src_install() {
	meson_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
	readme.gentoo_print_elog
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}

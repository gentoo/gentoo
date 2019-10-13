# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_MIN_API_VERSION="0.40"
VALA_MAX_API_VERSION="0.44"

inherit gnome.org gnome2-utils meson readme.gentoo-r1 vala xdg

DESCRIPTION="Play the classic two-player boardgame of chess"
HOMEPAGE="https://wiki.gnome.org/Apps/Chess"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.44:2
	>=x11-libs/gtk+-3.20.0:3
	>=gnome-base/librsvg-2.32.0:2[vala]
"
DEPEND="${RDEPEND}
	$(vala_depend)
	dev-util/itstool
	dev-libs/appstream-glib
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

DOC_CONTENTS="For being able to play against computer you will
need to install a chess engine like, for example, games-board/gnuchess"

src_prepare() {
	xdg_src_prepare
	vala_src_prepare
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

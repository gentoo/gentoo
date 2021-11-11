# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..10} )
VALA_MIN_API_VERSION="0.52"

inherit gnome.org gnome2-utils meson python-any-r1 readme.gentoo-r1 vala xdg

DESCRIPTION="Play the classic two-player boardgame of chess"
HOMEPAGE="https://wiki.gnome.org/Apps/Chess"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-libs/glib-2.44:2
	gui-libs/gtk:4
	>=gnome-base/librsvg-2.46.0:2
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

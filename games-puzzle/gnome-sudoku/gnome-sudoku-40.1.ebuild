# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )
VALA_MIN_API_VERSION="0.40"

inherit gnome.org gnome2-utils meson python-any-r1 vala xdg

DESCRIPTION="Test your logic skills in this number grid puzzle"
HOMEPAGE="https://wiki.gnome.org/Apps/Sudoku"

LICENSE="GPL-3+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	>=dev-libs/glib-2.40:2
	dev-libs/libgee:0.8=[introspection]
	>=x11-libs/gtk+-3.24.0:3[introspection]
	dev-libs/json-glib
	>=dev-libs/qqwing-1.3.4
	x11-libs/gdk-pixbuf:2[introspection]
	x11-libs/pango[introspection]
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	$(vala_depend)
	dev-libs/appstream-glib
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_prepare() {
	xdg_src_prepare
	vala_src_prepare
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}

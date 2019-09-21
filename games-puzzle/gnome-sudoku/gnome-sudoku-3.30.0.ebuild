# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_MIN_API_VERSION="0.36"

inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="Test your logic skills in this number grid puzzle"
HOMEPAGE="https://wiki.gnome.org/Apps/Sudoku"

LICENSE="GPL-3+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.40:2
	dev-libs/libgee:0.8=[introspection]
	dev-libs/json-glib
	>=dev-libs/qqwing-1.3.4
	x11-libs/gdk-pixbuf:2[introspection]
	>=x11-libs/gtk+-3.19.0:3[introspection]
	x11-libs/pango[introspection]
"
DEPEND="${RDEPEND}
	$(vala_depend)
	dev-libs/appstream-glib
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_prepare() {
	xdg_src_prepare
	vala_src_prepare

	# Make build compatible with vala release <0.38
	sed -e "s/\(--vapidir.*\)/\1, '--target-glib=2.38'/" -i meson.build || die
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_icon_cache_update
	gnome2_schemas_update
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org gnome2-utils meson xdg
DESCRIPTION="GNOME hexadecimal editor"
HOMEPAGE="https://wiki.gnome.org/Apps/Ghex"

LICENSE="GPL-2+ FDL-1.1+"
SLOT="2"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	>=dev-libs/atk-1.0.0
	>=dev-libs/glib-2.31.10:2
	>=x11-libs/gtk+-3.3.8:3
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/appstream-glib
	dev-libs/libxml2:2
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

# Requires unreleased appstream-glib-0.7.16 for tests to pass..
RESTRICT="test" # https://gitlab.gnome.org/GNOME/ghex/issues/18

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}

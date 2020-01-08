# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="Beat the odds in a poker-style dice game"
HOMEPAGE="https://wiki.gnome.org/Apps/Tali"

LICENSE="GPL-2+ FDL-1.1+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE=""

DEPEND="
	dev-libs/glib:2
	>=x11-libs/gtk+-3.16:3
"
RDEPEND="${DEPEND}
	>=gnome-base/librsvg-2.32:2
"
DEPEND="
	dev-libs/appstream-glib
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
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

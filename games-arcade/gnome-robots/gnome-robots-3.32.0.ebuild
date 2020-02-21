# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="Avoid the robots and make them crash into each other"
HOMEPAGE="https://wiki.gnome.org/Apps/Robots"

LICENSE="GPL-3+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

RDEPEND="
	>=x11-libs/gtk+-3.15:3
	>=dev-libs/glib-2.32:2
	>=gnome-base/librsvg-2.36.2:2
	dev-libs/libgnome-games-support:1=
	>=media-libs/libcanberra-0.26[gtk3]
"
DEPEND="${RDEPEND}"
BDEPEND="
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

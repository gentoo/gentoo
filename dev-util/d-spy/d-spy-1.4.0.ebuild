# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson

DESCRIPTION="D-spy is a blisteringly fast D-Bus debugger"
HOMEPAGE="https://wiki.gnome.org/Apps/d-spy"

LICENSE="GPL-3"
SLOT="1"
KEYWORDS="~amd64"

IUSE=""
# REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	>=gui-libs/gtk-4.6:4
	>=gui-libs/libadwaita-1.0:1
"
RDEPEND="
	${DEPEND}
	>=dev-libs/glib-2.68:2
	>=sys-apps/dbus-1
"
BDEPEND="
	dev-util/itstool
"

src_install() {
	meson_src_install
	mv "${ED}"/usr/share/appdata "${ED}"/usr/share/metainfo || die
}

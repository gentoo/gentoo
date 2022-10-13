# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson xdg

DESCRIPTION="D-spy is a blisteringly fast D-Bus debugger"
HOMEPAGE="https://wiki.gnome.org/Apps/d-spy https://gitlab.gnome.org/GNOME/d-spy"

LICENSE="GPL-3+ LGPL-3+"
SLOT="1"
KEYWORDS="~amd64"

DEPEND="
	>=dev-libs/glib-2.68:2
	>=gui-libs/gtk-4.6:4
	>=gui-libs/libadwaita-1.0:1
"
RDEPEND="
	${DEPEND}
	>=sys-apps/dbus-1
"
BDEPEND="
	dev-libs/appstream-glib
	dev-util/desktop-file-utils
	sys-devel/gettext
	virtual/pkgconfig
"

src_install() {
	meson_src_install
	mv "${ED}"/usr/share/appdata "${ED}"/usr/share/metainfo || die
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson xdg

DESCRIPTION="D-Spy is a simple tool to explore D-Bus connections"
HOMEPAGE="https://gitlab.gnome.org/GNOME/d-spy"

LICENSE="GPL-3+ LGPL-3+"
SLOT="1"
KEYWORDS="~amd64 ~arm64"

DEPEND="
	>=dev-libs/glib-2.76:2
	>=gui-libs/gtk-4.12:4
	>=gui-libs/libadwaita-1.4:1
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
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

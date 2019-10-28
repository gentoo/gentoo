# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
PYTHON_REQ_USE="sqlite"
HASH="6b4e4e7a2c17f0770c1e2b3354ae5a3a"
inherit python-r1 gnome2-utils meson xdg-utils

DESCRIPTION="Modern music player for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Lollypop"
SRC_URI="https://gitlab.gnome.org/World/${PN}/uploads/${HASH}/${P}.tar.xz"
KEYWORDS="amd64"

LICENSE="GPL-3"
SLOT="0"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

DEPEND="${PYTHON_DEPS}
	dev-libs/appstream-glib[introspection]
	dev-libs/glib:2
	dev-libs/gobject-introspection[cairo]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	gnome-base/gnome-common
	x11-libs/gtk+:3
"
BDEPEND="${DEPEND}
	dev-python/pkgconfig[${PYTHON_USEDEP}]
	dev-util/desktop-file-utils
	dev-util/itstool
	dev-util/intltool
"
RDEPEND="${DEPEND}
	app-crypt/libsecret[introspection]
	dev-libs/totem-pl-parser
	dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
	dev-python/dbus-python
	dev-python/pillow[${PYTHON_USEDEP}]
	>=dev-python/pylast-1.0.0[${PYTHON_USEDEP}]
	media-libs/gst-plugins-base:1.0[introspection]
"

RESTRICT="test"

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_gconf_install
	gnome2_schemas_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_gconf_uninstall
	gnome2_schemas_update
	xdg_desktop_database_update
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9} )
PYTHON_REQ_USE="sqlite"
inherit python-single-r1 gnome2-utils meson xdg

DESCRIPTION="Modern music player for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Lollypop"
SRC_URI="https://adishatz.org/${PN}/${P}.tar.xz"
KEYWORDS="amd64"

LICENSE="GPL-3"
SLOT="0"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

DEPEND="${PYTHON_DEPS}
	dev-libs/appstream-glib[introspection]
	dev-libs/glib:2
	dev-libs/gobject-introspection[cairo(+)]
	$(python_gen_cond_dep '
		dev-python/pycairo[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	')
	gnome-base/gnome-common
	x11-libs/gtk+:3
"
BDEPEND="${DEPEND}
	$(python_gen_cond_dep '
		dev-python/pkgconfig[${PYTHON_USEDEP}]
	')
	dev-util/desktop-file-utils
	dev-util/itstool
	dev-util/intltool
"
RDEPEND="${DEPEND}
	app-crypt/libsecret[introspection]
	dev-libs/totem-pl-parser
	$(python_gen_cond_dep '
		dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
		dev-python/dbus-python
		dev-python/pillow[${PYTHON_USEDEP}]
		>=dev-python/pylast-1.0.0[${PYTHON_USEDEP}]
	')
	media-libs/gst-plugins-base:1.0[introspection]
"

RESTRICT="test"

src_install() {
	meson_src_install
	python_optimize
}

pkg_preinst() {
	gnome2_schemas_savelist
	xdg_pkg_preinst
}

pkg_postinst() {
	gnome2_gconf_install
	gnome2_schemas_update
	xdg_pkg_postinst
}

pkg_postrm() {
	gnome2_gconf_uninstall
	gnome2_schemas_update
	xdg_pkg_postrm
}

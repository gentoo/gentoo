# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1 xdg-utils

DESCRIPTION="A frontend for find, (s)locate, doodle, tracker, beagle, strigi and pinot"
HOMEPAGE="https://docs.xfce.org/apps/catfish/start"
SRC_URI="https://archive.xfce.org/src/apps/catfish/${PV%.*}/${P}.tar.bz2"

# yep, GPL-2 only
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	dev-libs/gobject-introspection
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pexpect[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	x11-libs/gdk-pixbuf[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/pango[introspection]
	virtual/freedesktop-icon-theme
"
BDEPEND="
	dev-python/python-distutils-extra[${PYTHON_USEDEP}]
	sys-devel/gettext
"

python_install() {
	distutils-r1_python_install
	python_optimize
	rm -r "${ED}"/usr/share/doc/catfish || die
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

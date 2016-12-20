# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils gnome2-utils

DESCRIPTION="An ultra-lightweight IDE, that embeds Vim, a terminal emulator, and a file browser"
HOMEPAGE="https://github.com/aliafshar/a8"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND=">=dev-python/dbus-python-1[${PYTHON_USEDEP}]
	dev-python/logbook[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/pygtk-2.22[${PYTHON_USEDEP}]
	>=dev-python/pygtkhelpers-0.4.3[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=x11-libs/vte-0.28.2-r206:0[python,${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	app-editors/gvim
	app-editors/vim"

PATCHES=( "${FILESDIR}"/${P}-argparse.patch )

python_install_all() {
	distutils-r1_python_install_all
	doicon -s 48 a8/data/icons/a8.png
	make_desktop_entry ${PN} ${PN} ${PN} 'Development;IDE'
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}

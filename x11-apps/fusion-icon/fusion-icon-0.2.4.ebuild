# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 gnome2-utils

DESCRIPTION="Compiz Fusion Tray Icon and Manager"
HOMEPAGE="http://compiz.org"
SRC_URI="https://github.com/compiz-reloaded/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+gtk qt5"

REQUIRED_USE="|| ( gtk qt5 )"

RDEPEND="
	dev-python/compizconfig-python[${PYTHON_USEDEP}]
	x11-apps/xvinfo
	x11-wm/compiz
	gtk? ( dev-python/pygobject:3[${PYTHON_USEDEP}] )
	qt5? ( dev-python/PyQt5[gui,widgets,${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}"

python_configure_all() {
	esetup.py build \
		$(use gtk && echo --with-gtk=3) \
		$(use qt5 && echo --with-qt=5)
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}

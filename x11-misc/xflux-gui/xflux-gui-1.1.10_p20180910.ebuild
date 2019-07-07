# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

MY_PV="a3b55da976053fc978b29d191db52dfb8da2f8ee"
MY_P="fluxgui-${MY_PV}"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 gnome2-utils

DESCRIPTION="A GUI for f.lux"
HOMEPAGE="https://justgetflux.com/"
SRC_URI="https://github.com/xflux-gui/fluxgui/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

KEYWORDS="-* amd64 x86"
LICENSE="MIT"
SLOT="0"

RDEPEND="dev-libs/libappindicator:2[python,${PYTHON_USEDEP}]
	dev-python/gconf-python[${PYTHON_USEDEP}]
	dev-python/pexpect[${PYTHON_USEDEP}]
	dev-python/pygtk[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	gnome-base/libglade
	x11-libs/libXxf86vm
	x11-misc/xflux"

S="${WORKDIR}/${MY_P}"

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}

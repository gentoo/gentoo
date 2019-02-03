# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 gnome2-utils

DESCRIPTION="A GUI for f.lux"
HOMEPAGE="https://justgetflux.com/"
SRC_URI="https://github.com/xflux-gui/fluxgui/archive/v${PV}.tar.gz -> ${P}.tar.gz"

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

S="${WORKDIR}/fluxgui-${PV}"

pkg_postinst() {
	# Update Gnome icon cache on install
	gnome2_icon_cache_update
}

pkg_postrm() {
	# Update Gnome icon cache on uninstall
	gnome2_icon_cache_update
}

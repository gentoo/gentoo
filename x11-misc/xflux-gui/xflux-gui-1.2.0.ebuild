# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7} )

inherit distutils-r1 xdg-utils

DESCRIPTION="A GUI for f.lux"
HOMEPAGE="https://justgetflux.com/"
SRC_URI="https://github.com/${PN}/fluxgui/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

RDEPEND="
	dev-libs/libappindicator:3
	dev-python/pexpect[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	x11-libs/libXxf86vm
	x11-misc/xflux
"

S="${WORKDIR}/fluxgui-${PV}"

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

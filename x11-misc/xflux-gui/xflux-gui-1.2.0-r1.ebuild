# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1 gnome2-utils xdg-utils

DESCRIPTION="A GUI for f.lux"
HOMEPAGE="https://justgetflux.com/"
SRC_URI="https://github.com/${PN}/fluxgui/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* amd64 x86"

PATCHES=( "${FILESDIR}/${P}-disable-gschemas-compiled.patch" )

RDEPEND="
	dev-libs/libappindicator:3
	dev-python/pexpect[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	x11-libs/libXxf86vm
	x11-misc/xflux
"

S="${WORKDIR}/fluxgui-${PV}"

python_install() {
	# Don't let the package compiling the schemas,
	# as this could cause a file collision
	export DISABLE_GSCHEMAS_COMPILED="true"

	distutils-r1_python_install
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_desktop_database_update
	xdg_icon_cache_update
}

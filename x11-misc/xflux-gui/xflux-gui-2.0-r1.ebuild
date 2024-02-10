# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 gnome2-utils

DESCRIPTION="A GUI for f.lux"
HOMEPAGE="https://github.com/xflux-gui/fluxgui/"
SRC_URI="https://github.com/${PN}/fluxgui/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/fluxgui-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

RDEPEND="
	dev-libs/libayatana-appindicator
	dev-python/pexpect[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	x11-libs/libXxf86vm
	x11-misc/xflux
"

python_compile() {
	# Don't let the package compiling the schemas,
	# as this could cause a file collision
	export DISABLE_GSCHEMAS_COMPILED="true"

	distutils-r1_python_compile
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

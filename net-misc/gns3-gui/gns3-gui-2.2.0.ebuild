# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1 desktop xdg-utils

DESCRIPTION="Graphical Network Simulator"
HOMEPAGE="https://www.gns3.com/ https://github.com/GNS3/gns3-gui"
SRC_URI="https://github.com/GNS3/gns3-gui/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

#net-misc/gns3-server version should always match gns3-gui version
CDEPEND="${PYTHON_DEPS}"
RDEPEND="${CDEPEND}
	~dev-python/jsonschema-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/distro-1.3.0[${PYTHON_USEDEP}]
	dev-python/raven[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/PyQt5[gui,network,svg,websockets,widgets,${PYTHON_USEDEP}]
	~net-misc/gns3-server-${PV}[${PYTHON_USEDEP}]"

DEPEND="${CDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_install_all() {
	distutils-r1_python_install_all

	for x in 128 256; do
		doicon -s $x "resources/images/gns3_icon_${x}x${x}.png"
	done

	make_desktop_entry "gns3" "GNS3" "gns3_icon_128x128" "Utility"
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..8} )

inherit distutils-r1 desktop xdg-utils

DESCRIPTION="Graphical Network Simulator"
HOMEPAGE="https://www.gns3.com/"
SRC_URI="https://github.com/GNS3/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

#net-misc/gns3-server version should always match gns3-gui version

RDEPEND="
	python_targets_python3_6? ( ~dev-python/jsonschema-2.6.0[${PYTHON_USEDEP}] )
	python_targets_python3_7? ( ~dev-python/jsonschema-2.6.0[${PYTHON_USEDEP}] )
	python_targets_python3_8? ( ~dev-python/jsonschema-3.2.0[${PYTHON_USEDEP}] )
	>=dev-python/raven-5.23.0[${PYTHON_USEDEP}]
	~dev-python/psutil-5.6.6[${PYTHON_USEDEP}]
	>=dev-python/distro-1.3.0[${PYTHON_USEDEP}]
	dev-python/PyQt5[gui,network,svg,websockets,widgets,${PYTHON_USEDEP}]
"

python_install_all() {
	distutils-r1_python_install_all

	doicon "resources/images/gns3.ico"
	make_desktop_entry "gns3" "GNS3" "gns3.ico" "Utility"
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1 eutils

DESCRIPTION="Graphical Network Simulator"
HOMEPAGE="http://www.gns3.net/"
SRC_URI="https://github.com/GNS3/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# tests are severely broken upstream and they have been notified
RESTRICT="test"

#net-misc/gns3-server version should always match gns3-gui version

RDEPEND="
	>=dev-python/libcloud-0.15.1[${PYTHON_USEDEP}]
	>=dev-python/ws4py-0.3.4[${PYTHON_USEDEP}]
	>=dev-python/requests-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/paramiko-1.15.1[${PYTHON_USEDEP}]
	~net-misc/gns3-server-${PV}[${PYTHON_USEDEP}]
	dev-python/PyQt5[gui,network,svg,websockets,widgets,${PYTHON_USEDEP}]
"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

src_prepare() {
	default

	rm -rf tests || die
}

python_install_all() {
	distutils-r1_python_install_all

	doicon "${WORKDIR}/${P}/resources/images/gns3.ico"
	make_desktop_entry "gns3" "GNS3" "/usr/share/pixmaps/gns3.ico" "Utility"
}

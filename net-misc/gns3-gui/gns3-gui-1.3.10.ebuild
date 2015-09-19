# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Graphical Network Simulator"
HOMEPAGE="http://www.gns3.net/"
SRC_URI="https://github.com/GNS3/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+qt4 qt5"

REQUIRED_USE="
	?? ( qt4 qt5 )
"

#net-misc/gns3-server version should always match gns3-gui version

RDEPEND="
	>=dev-python/libcloud-0.15.1[${PYTHON_USEDEP}]
	>=dev-python/ws4py-0.3.4[${PYTHON_USEDEP}]
	>=dev-python/requests-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/paramiko-1.15.1[${PYTHON_USEDEP}]
	>=net-misc/gns3-converter-1.2.3[${PYTHON_USEDEP}]
	=net-misc/gns3-server-$PV[${PYTHON_USEDEP}]
	qt4? (
		dev-qt/qtgui:4[accessibility]
		dev-qt/qtsvg:4
		>=dev-python/PyQt4-4.11.2[X,svg,${PYTHON_USEDEP}]
		)
	qt5? (
		dev-qt/qtgui:5
		dev-qt/qtsvg:5
		dev-python/PyQt5[svg,${PYTHON_USEDEP}]
	)
"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_install_all() {
	distutils-r1_python_install_all

	doicon "${WORKDIR}/${P}/resources/images/gns3.ico"
	make_desktop_entry "gns3" "GNS3" "/usr/share/pixmaps/gns3.ico" "Utility"
}

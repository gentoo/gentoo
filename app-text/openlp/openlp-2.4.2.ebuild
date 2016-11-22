# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python3_4)
PYTHON_REQ_USE='sqlite'

inherit distutils-r1

DESCRIPTION="Free church presentation software"
HOMEPAGE="http://openlp.org/"
SRC_URI="https://get.openlp.org/${PV}/OpenLP-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/alembic[${PYTHON_USEDEP}]
	dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
	>=dev-python/pyenchant-1.3[${PYTHON_USEDEP}]
	dev-python/pyodbc
	dev-python/PyQt5[multimedia,gui,network,svg,webkit,${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/sip[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-0.5[${PYTHON_USEDEP}]
	dev-python/sqlalchemy-migrate[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

S=${WORKDIR}/OpenLP-${PV}

PATCHES=( "${FILESDIR}"/OpenLP-${PV}-disable-tests.patch )

python_install_all() {
	distutils-r1_python_install_all
	domenu  resources/openlp.desktop
	mv   "${D}"/usr/bin/openlp.py "${D}"/usr/bin/openlp
	doicon -s scalable resources/images/openlp.svg
}

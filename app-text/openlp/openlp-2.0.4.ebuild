# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='sqlite'

inherit distutils-r1

DESCRIPTION="Free church presentation software"
HOMEPAGE="http://openlp.org/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/OpenLP-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/beautifulsoup:python-2[${PYTHON_USEDEP}]
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
	dev-python/pyenchant[${PYTHON_USEDEP}]
	dev-python/pyodbc
	dev-python/PyQt4[X,multimedia,phonon,webkit,${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/sip[${PYTHON_USEDEP}]
	dev-python/sqlalchemy[${PYTHON_USEDEP}]
	dev-python/sqlalchemy-migrate[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

S=${WORKDIR}/OpenLP-${PV}

python_install_all() {
	distutils-r1_python_install_all
	domenu  resources/openlp.desktop
	dosym  openlp.pyw /usr/bin/openlp
	doicon -s scalable resources/images/openlp.svg
}

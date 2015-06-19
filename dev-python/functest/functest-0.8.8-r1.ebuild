# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/functest/functest-0.8.8-r1.ebuild,v 1.3 2015/03/08 23:48:39 pacho Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Functest is a test tool/framework for testing in Python"
HOMEPAGE="http://code.google.com/p/functest/ http://pypi.python.org/pypi/functest"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

python_prepare_all() {
	# purge test folder to avoid file collisions
	sed -e "s:find_packages():find_packages(exclude=['tests','tests.*']):" -i setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	PATH="scripts:${PATH}" nosetests || die "Tests fail with ${EPYTHON}"
}

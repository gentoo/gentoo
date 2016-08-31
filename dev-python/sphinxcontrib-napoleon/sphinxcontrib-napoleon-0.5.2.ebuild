# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} )

inherit distutils-r1

DESCRIPTION="Allow a different format in dosctrings for better clarity"
HOMEPAGE="https://pypi.python.org/pypi/sphinxcontrib-napoleon"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=test

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/six-1.5.2[${PYTHON_USEDEP}]
	>=dev-python/pockets-0.3[${PYTHON_USEDEP}]
	test? ( >=dev-python/coverage-3.6[${PYTHON_USEDEP}]
			>=dev-python/docutils-0.10[${PYTHON_USEDEP}]
			>=dev-python/flake8-2.0[${PYTHON_USEDEP}]
			>=dev-python/mock-1.0.1[${PYTHON_USEDEP}]
			>=dev-python/nose-1.3.0[${PYTHON_USEDEP}]
			>=dev-python/sphinx-1.2.1[${PYTHON_USEDEP}]
	)
"
src_prepare() {
	epatch "${FILESDIR}/no_installed_tests.patch" || die
}

python_test() {
	nosetests tests || die "tests failed with ${EPYTHON}"
}

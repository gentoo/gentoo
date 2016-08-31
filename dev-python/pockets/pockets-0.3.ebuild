# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} )

inherit distutils-r1

IUSE="test"

DESCRIPTION="A collection of helpful Python tools"
HOMEPAGE="https://pypi.python.org/pypi/pockets"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-python/six-1.5.2[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
	>=dev-python/coverage-3.7.1[${PYTHON_USEDEP}]
	>=dev-python/flake8-2.3.0[${PYTHON_USEDEP}]
	test? ( >=dev-python/pytest-2.6.4[${PYTHON_USEDEP}]
	        dev-python/nose[${PYTHON_USEDEP}]
	      )
	dev-python/setuptools[${PYTHON_USEDEP}]

"
src_prepare() {
	epatch "${FILESDIR}/no_installed_tests.patch" || die
}
python_test() {
	nosetests tests || die "tests failed with ${EPYTHON}"
}

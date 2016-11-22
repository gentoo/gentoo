# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5} pypy )

inherit distutils-r1

DESCRIPTION="Login session support for Flask"
HOMEPAGE="https://pypi.python.org/pypi/Flask-Login"
SRC_URI="https://github.com/maxcountryman/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
# pypi tarball is missing tests

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-python/flask-0.10[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/blinker[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/unittest2[${PYTHON_USEDEP}]' 'python2*' pypy)
	)"

PATCHES=( "${FILESDIR}/${P}-fix-tests-python2.patch" )

python_test() {
	nosetests -v || die "Tests fail with ${EPYTHON}"
}

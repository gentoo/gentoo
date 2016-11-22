# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} pypy )

inherit distutils-r1

DESCRIPTION="Flexible and efficient upload handling for Flask"
HOMEPAGE="http://pythonhosted.org/Flask-Testing/
	https://pypi.python.org/pypi/Flask-Testing/"
SRC_URI="https://github.com/maxcountryman/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
# use the GitHub tarball since the pypi-tarball does not contain the tests

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-python/flask-0.5[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

PATCHES=( "${FILESDIR}/${P}-remove-deprecated-module.patch" )

python_test() {
	nosetests || die "Testing failed with ${EPYTHON}"
}

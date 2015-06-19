# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/flask-testing/flask-testing-0.4.1.ebuild,v 1.2 2014/05/06 15:20:26 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

DESCRIPTION="Unit testing for Flask"
HOMEPAGE="http://pythonhosted.org/Flask-Testing/
	https://pypi.python.org/pypi/Flask-Testing/"
MY_PN="Flask-Testing"
MY_P="${MY_PN}-${PV}"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/flask[${PYTHON_USEDEP}]
	dev-python/twill[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/blinker[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MY_P}"
DISTUTILS_NO_PARALLEL_BUILD=1

python_test() {
	nosetests || die "Testing failed with ${EPYTHON}"
}

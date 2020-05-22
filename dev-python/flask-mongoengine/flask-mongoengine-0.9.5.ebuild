# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1

RESTRICT="test" # requires running MongoDB server

DESCRIPTION="Flask support for MongoDB and with WTF model forms"
HOMEPAGE="https://pypi.org/project/flask-mongoengine/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-python/flask-0.8[${PYTHON_USEDEP}]
	>=dev-python/mongoengine-0.8[${PYTHON_USEDEP}]
	>=dev-python/flask-wtf-0.8.3[${PYTHON_USEDEP}]"

distutils_enable_sphinx docs
distutils_enable_tests pytest

python_prepare_all() {
	# fix distutils sandbox violation due to missing test-deps in normal build
	sed -i '/test_requirements/d' setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests || die "Testing failed with ${EPYTHON}"
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

RESTRICT="test" # broken

DESCRIPTION="Flask support for MongoDB and with WTF model forms"
HOMEPAGE="https://pypi.python.org/pypi/flask-mongoengine/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RDEPEND=">=dev-python/flask-0.8[${PYTHON_USEDEP}]
		>=dev-python/mongoengine-0.7.10[${PYTHON_USEDEP}]
		dev-python/flask-wtf[${PYTHON_USEDEP}]
	"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}]
	)"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	nosetests || die "Testing failed with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}

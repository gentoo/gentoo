# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3} )

inherit distutils-r1

DESCRIPTION="A high-level Python library that makes it easier to use Apache Zookeeper"
HOMEPAGE="https://kazoo.readthedocs.org/ https://github.com/python-zk/kazoo/ https://pypi.python.org/pypi/kazoo/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc gevent test"

RDEPEND="
	>=dev-python/zope-interface-3.8.0[${PYTHON_USEDEP}]
	gevent? ( dev-python/gevent[$(python_gen_usedep 'python2*')] )
"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		dev-python/repoze-sphinx-autointerface[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? ( dev-python/mock[${PYTHON_USEDEP}] )
"

# not all test deps are in the tree
RESTRICT="test"

python_compile_all() {
	use doc && { sphinx-build -b html docs docs/_build/html || die; }
}

python_test() {
	esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	local DOCS=( {CHANGES,CONTRIBUTING,README}.rst )
	distutils-r1_python_install_all
}

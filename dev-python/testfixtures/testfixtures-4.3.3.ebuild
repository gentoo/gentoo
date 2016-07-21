# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="A collection of helpers and mock objects for unit tests and doc tests"
HOMEPAGE="https://pypi.python.org/pypi/testfixtures/ https://github.com/Simplistix/testfixtures"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/pkginfo[${PYTHON_USEDEP}]' python2_7 pypy )
	)
	test? (
		dev-python/manuel[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/nose-cover3[${PYTHON_USEDEP}]
		dev-python/nose_fixes[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7)
	)"

python_prepare_all() {
	# Makefile comes set pointing at a wrong location
	sed -e 's:../bin/sphinx-build:/usr/bin/sphinx-build:' -i docs/Makefile || die
	# Prevent un-needed download during build, fix Makefile for doc build
	sed -e '/'sphinx.ext.intersphinx'/d' -i docs/conf.py || die
	distutils-r1_python_prepare_all
}

python_prepare() {
	# remove test that tests the stripped zope-component test_components.ComponentsTests
	rm -f testfixtures/tests/test_components.py || die

	distutils-r1_python_prepare
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	nosetests || die
}

python_install_all() {
	use doc && HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}

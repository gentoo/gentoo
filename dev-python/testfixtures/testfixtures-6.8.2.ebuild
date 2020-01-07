# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

DESCRIPTION="A collection of helpers and mock objects for unit tests and doc tests"
HOMEPAGE="https://pypi.org/project/testfixtures/ https://github.com/Simplistix/testfixtures"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/pkginfo[${PYTHON_USEDEP}]' python2_7 pypy )
	)
	test? (
		dev-python/django[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7)
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-django[${PYTHON_USEDEP}]
		dev-python/sybil[${PYTHON_USEDEP}]
		>=dev-python/twisted-18[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	# Prevent un-needed download during build, fix Makefile for doc build
	sed -e '/'sphinx.ext.intersphinx'/d' -i docs/conf.py || die

	# remove test that tests the stripped zope-component test_components.ComponentsTests
	rm -f testfixtures/tests/test_components.py docs/components.txt || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	PYTHONPATH="." \
	DJANGO_SETTINGS_MODULE=testfixtures.tests.test_django.settings \
	pytest -vv || die
}

python_install_all() {
	use doc && HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}

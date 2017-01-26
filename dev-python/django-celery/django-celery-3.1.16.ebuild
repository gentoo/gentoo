# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} )
PYTHON_REQ_USE="sqlite(+)"

inherit distutils-r1 eutils

DESCRIPTION="Celery Integration for Django"
HOMEPAGE="http://celeryproject.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc examples test"

# Python testsuite fails when built against dev-python/django-1.8.5
# with ValueError: save() prohibited to prevent data loss due to
# unsaved related object 'interval'.

PY2_USEDEP=$(python_gen_usedep 'python2*')
RDEPEND=">=dev-python/celery-3.1.15[${PYTHON_USEDEP}]
	>dev-python/django-1.4[${PYTHON_USEDEP}]
	<=dev-python/django-1.7.11[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/django-nose[${PYTHON_USEDEP}]
		>=dev-python/coverage-3.0[${PYTHON_USEDEP}]
		dev-python/nose-cover3[${PYTHON_USEDEP}]
		dev-python/mock[${PY2_USEDEP}]
		dev-python/python-memcached[${PY2_USEDEP}] )
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-issuetracker[${PY2_USEDEP}]
		dev-python/python-memcached[${PY2_USEDEP}]
	)"

PY27_REQUSE="$(python_gen_useflags 'python2*')"
REQUIRED_USE="
	doc? ( ${PY27_REQUSE} )"

PATCHES=( "${FILESDIR}/${P}-py3-test-failures.patch" )

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	# https://github.com/celery/django-celery/issues/342
	"${PYTHON}" tests/manage.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/.build/html/. )
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}

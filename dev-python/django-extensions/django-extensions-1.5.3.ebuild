# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit distutils-r1 eutils

DESCRIPTION="Django Command Extensions"
HOMEPAGE="https://github.com/django-extensions/django-extensions http://django-extensions.readthedocs.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD || ( MIT GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

# Req'd for tests
DISTUTILS_IN_SOURCE_BUILD=1

RDEPEND="
	>=dev-python/django-1.5.4[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		>=dev-python/django-1.5.4[${PYTHON_USEDEP}]
		dev-python/shortuuid[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		dev-python/tox[${PYTHON_USEDEP}]
		)"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	py.test || die
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}

pkg_postinst() {
	echo ""
	elog "Further enhancements can be achieved by installing the following packages:"
	echo ""
	optfeature "Use ipython in shell_plus" dev-python/ipython
	optfeature "Use ptpython in shell_plus" dev-python/ptpython
	optfeature "Renders a graphical overview of your project or specified apps." dev-python/pygraphviz
	optfeature "sync your MEDIA_ROOT and STATIC_ROOT folders to S3" dev-python/boto
	optfeature "RunServerPlus-typical runserver with Werkzeug debugger baked in" dev-python/werkzeug dev-python/watchdog
}

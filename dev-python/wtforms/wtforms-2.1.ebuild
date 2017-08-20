# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy )

inherit distutils-r1

MY_PN="WTForms"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Flexible forms validation and rendering library for python web development"
HOMEPAGE="http://wtforms.simplecodes.com/ https://pypi.python.org/pypi/WTForms"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc test"

S="${WORKDIR}/${MY_P}"

RDEPEND="
	app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( >=dev-python/sphinx-0.6[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	test? (
		dev-python/Babel[${PYTHON_USEDEP}]
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
		dev-python/webob[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	# Extension-tests are written for an older version of Django
	sed \
		-e "s|'ext_django.tests', ||" \
		-i tests/runtests.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python2_7 python3_{6..9} )
inherit distutils-r1

MY_PN="WTForms"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Flexible forms validation and rendering library for python web development"
HOMEPAGE="https://wtforms.readthedocs.io/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

S="${WORKDIR}/${MY_P}"

BDEPEND="
	test? (
		dev-python/Babel[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
		dev-python/webob[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs

python_prepare_all() {
	# Extension-tests are written for an older version of Django
	# Disable pep8 even when it is installed
	sed \
		-e "s|'ext_django.tests', ||" \
		-e "/import pep8/d" \
		-e "s|has_pep8 = True|has_pep8 = False|" \
		-i tests/runtests.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	"${EPYTHON}" tests/runtests.py -v || die
}

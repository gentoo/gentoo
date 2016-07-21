# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="ISO country, subdivision, language, currency, script definitions and their translations"
HOMEPAGE="https://pypi.python.org/pypi/pycountry"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~sparc ~ppc ~x86"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_test() {
	# https://bitbucket.org/techtonik/pycountry/issue/8/test_locales-pycountry-015-pypy
	pushd "${BUILD_DIR}"/lib > /dev/null
	if [[ "${EPYTHON}" == pypy || "${EPYTHON}" == pypy3 ]]; then
		sed -e 's:test_locales:_&:' -i pycountry/tests/test_general.py || die
	fi
		py.test ${PN}/tests/test_general.py || die
	popd > /dev/null
}

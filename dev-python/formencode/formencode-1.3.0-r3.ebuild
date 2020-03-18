# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_6 )
inherit distutils-r1

MY_PN="FormEncode"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="HTML form validation, generation, and conversion package"
HOMEPAGE="http://formencode.org/ https://pypi.org/project/FormEncode/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.zip"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ~sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="doc test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/dnspython[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pycountry[${PYTHON_USEDEP}] )"
RDEPEND=""

RESTRICT="test"
DOCS=( docs/. )

S="${WORKDIR}/${MY_P}"
DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	sed -e '/package_data.*..docs/d' -i setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	# https://github.com/formencode/formencode/issues/78
	# 5 failures under py2.7. Although the package claims to cater to py3, the suite fails horribly
	# Main problem is that it is written requiring to be system installed, then run.
	# Suite found to pass on extended testing using tox.
	nosetests || die "tests failed under ${EPYTHON}"
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/formencode/formencode-1.3.0-r1.ebuild,v 1.1 2015/06/30 13:09:16 jlec Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

MY_PN="FormEncode"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="HTML form validation, generation, and conversion package"
HOMEPAGE="http://formencode.org/ http://pypi.python.org/pypi/FormEncode"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.zip"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="doc test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pycountry[${PYTHON_USEDEP}]
		>=dev-python/dnspython-1.12.0-r1[${PYTHON_USEDEP}] )"
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

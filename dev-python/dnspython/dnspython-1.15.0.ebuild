# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1

DESCRIPTION="DNS toolkit for Python"
HOMEPAGE="http://www.dnspython.org/ https://pypi.python.org/pypi/dnspython"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="examples test"

RDEPEND="dev-python/pycrypto[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	app-arch/unzip"

# For testsuite
DISTUTILS_IN_SOURCE_BUILD=1

python_test() {
	cd tests || die
	"${PYTHON}" utest.py || die "tests failed under ${EPYTHON}"
	einfo "Testsuite passed under ${EPYTHON}"
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}

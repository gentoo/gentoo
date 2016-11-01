# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python3_{4,5} )

inherit distutils-r1

MY_PN="${PN}3"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="DNS toolkit for Python"
HOMEPAGE="http://www.dnspython.org/ https://pypi.python.org/pypi/dnspython"
SRC_URI="http://www.dnspython.org/kits3/${PV}/${MY_P}.zip"

LICENSE="ISC"
SLOT="py3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="examples test"

RDEPEND="dev-python/pycrypto[${PYTHON_USEDEP}]
	!dev-python/dnspython:0"
DEPEND="${RDEPEND}
	!dev-python/dnspython:0
	app-arch/unzip"

S="${WORKDIR}/${MY_P}"

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

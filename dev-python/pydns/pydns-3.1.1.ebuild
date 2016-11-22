# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python3_4 )

inherit distutils-r1

MY_PN="${PN/py/py3}"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Python DNS (Domain Name System) library"
HOMEPAGE="https://launchpad.net/py3dns"
SRC_URI="https://launchpad.net/${MY_PN}/trunk/${PV}/+download/${MY_P}.tar.gz"

LICENSE="CNRI"
SLOT="3"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~sparc ~x86"
IUSE="examples"

DEPEND=""
RDEPEND=""

# Most if not all of the tests require network access.
RESTRICT=test

S="${WORKDIR}/${MY_P}"

python_test() {
	# Some of the tests are broken.
	for test in tests/{test{,2,4}.py,testsrv.py}
	do
		"${PYTHON}" ${test} || die
	done

	"${PYTHON}" tests/test5.py example.org || die
}

python_install_all() {
	use examples && local EXAMPLES=( ./{tests,tools}/. )
	distutils-r1_python_install_all
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3} )

inherit distutils-r1

DESCRIPTION="A repository of test results"
HOMEPAGE="https://launchpad.net/testscenarios"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		test? ( ${RDEPEND}
			dev-python/testresources[${PYTHON_USEDEP}]
			dev-python/testscenarios[${PYTHON_USEDEP}]
			dev-python/pytz[${PYTHON_USEDEP}]
		)"
#>=dev-python/subunit-0.0.10[${PYTHON_USEDEP}]
#>=dev-python/testtools-0.9.30[${PYTHON_USEDEP}]
#dev-python/fixtures[${PYTHON_USEDEP}]
#bzr is listed but presumably req'd for a live repo test run
RDEPEND=">=dev-python/subunit-0.0.10[${PYTHON_USEDEP}]
		>=dev-python/testtools-0.9.30[${PYTHON_USEDEP}]
		dev-python/fixtures[${PYTHON_USEDEP}]"

# Required for test phase
DISTUTILS_IN_SOURCE_BUILD=1

python_test() {
	"${PYTHON}" ./testr init || die
	"${PYTHON}" setup.py testr --coverage || die "tests failed under ${EPYTHON}"
}

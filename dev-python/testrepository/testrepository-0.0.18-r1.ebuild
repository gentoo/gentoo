# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/testrepository/testrepository-0.0.18-r1.ebuild,v 1.12 2015/04/14 12:51:27 ago Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="A repository of test results"
HOMEPAGE="https://launchpad.net/testscenarios"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		test? ( ${RDEPEND}
			dev-python/testresources[${PYTHON_USEDEP}]
			dev-python/testscenarios[${PYTHON_USEDEP}]
			dev-python/pytz[${PYTHON_USEDEP}]
		)"
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

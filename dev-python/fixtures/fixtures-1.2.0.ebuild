# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/fixtures/fixtures-1.2.0.ebuild,v 1.1 2015/06/14 08:41:22 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Fixtures, reusable state for writing clean tests and more"
HOMEPAGE="https://launchpad.net/python-fixtures https://pypi.python.org/pypi/fixtures"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="|| ( Apache-2.0 BSD )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

# nose not listed but provides coverage output of tests
# run of test files by python lacks any output except on fail
DEPEND="test? ( >=dev-python/testtools-0.9.22[${PYTHON_USEDEP}]
		dev-python/extras[${PYTHON_USEDEP}] )"
RDEPEND=">=dev-python/testtools-0.9.22"
#DISTUTILS_IN_SOURCE_BUILD=1

python_test() {
	emake check
}

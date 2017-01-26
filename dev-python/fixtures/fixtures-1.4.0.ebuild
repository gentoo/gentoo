# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Fixtures, reusable state for writing clean tests and more"
HOMEPAGE="https://launchpad.net/python-fixtures https://pypi.python.org/pypi/fixtures"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="|| ( Apache-2.0 BSD )"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"

# nose not listed but provides coverage output of tests
# run of test files by python lacks any output except on fail
RDEPEND="
	>=dev-python/pbr-0.11[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/testtools-0.9.22[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/mock[${PYTHON_USEDEP}] )"
#DISTUTILS_IN_SOURCE_BUILD=1

python_test() {
	emake check
}

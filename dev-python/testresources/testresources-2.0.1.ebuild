# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{5,6,7,8} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="A pyunit extension for managing expensive test resources"
HOMEPAGE="https://launchpad.net/testresources"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/testtools[${PYTHON_USEDEP}]
		dev-python/fixtures[${PYTHON_USEDEP}]
	)"
RDEPEND=""

python_prepare_all() {
	sed \
		-e 's:testBasicSortTests:_&:g' \
		-i testresources/tests/test_optimising_test_suite.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests --verbose || die "Tests failed under ${EPYTHON}"
}

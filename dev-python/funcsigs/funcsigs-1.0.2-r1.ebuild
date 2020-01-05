# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6,3_7} pypy3 )

inherit distutils-r1

DESCRIPTION="Python function signatures backport from PEP362 for Python 2.7-3.5"
HOMEPAGE="https://pypi.org/project/funcsigs/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/unittest2[${PYTHON_USEDEP}] )"

PATCHES=(
	# This patch disables some tests for pypy as they do not work as expected.
	# This has been reported upstream
	# https://github.com/testing-cabal/funcsigs/issues/10
	"${FILESDIR}/${P}-fix-pypy3-tests.patch"
)

python_test() {
	esetup.py test
}

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6..9} pypy3 )

inherit distutils-r1

DESCRIPTION="Useful extra bits for Python that should be in the standard library"
HOMEPAGE="https://github.com/testing-cabal/extras/ https://pypi.org/project/extras/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? ( dev-python/testtools[${PYTHON_USEDEP}] )"

python_test() {
	"${EPYTHON}" ${PN}/tests/test_extras.py || die
}

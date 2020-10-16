# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{6..9} pypy3 )

inherit distutils-r1

DESCRIPTION="The new features in unittest backported to Python 2.4+"
HOMEPAGE="https://pypi.org/project/unittest2/ https://github.com/testing-cabal/unittest-ext"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

RDEPEND="
	dev-python/linecache2[${PYTHON_USEDEP}]
	>=dev-python/six-1.4[${PYTHON_USEDEP}]
	dev-python/traceback2[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

PATCHES=(
	"${FILESDIR}"/remove-argparse-dependence.patch
	"${FILESDIR}"/${P}-python3.5-test.patch
)

python_test() {
	"${PYTHON}" -m unittest2 discover --verbose ||
		die "tests failed under ${EPYTHON}"
}

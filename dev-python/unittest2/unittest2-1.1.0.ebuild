# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="The new features in unittest backported to Python 2.4+"
HOMEPAGE="https://pypi.org/project/unittest2/ https://github.com/testing-cabal/unittest-ext"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

CDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/linecache2[${PYTHON_USEDEP}]
	>=dev-python/six-1.4[${PYTHON_USEDEP}]
	dev-python/traceback2[${PYTHON_USEDEP}]
"
DEPEND="${CDEPEND}"
RDEPEND="${CDEPEND}"

PATCHES=(
	"${FILESDIR}"/remove-argparse-dependence.patch
	"${FILESDIR}"/${P}-python3.5-test.patch
)

python_test() {
	"${PYTHON}" -m unittest2 discover --verbose || die "tests failed under ${EPYTHON}"
}

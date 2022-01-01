# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..10} )
inherit distutils-r1

DESCRIPTION="A pure-Python memory-efficient packed representation for bit arrays"
HOMEPAGE="https://engineering.purdue.edu/kak/dist/ https://pypi.org/project/BitVector/"
SRC_URI="https://engineering.purdue.edu/kak/dist/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

python_test() {
	"${PYTHON}" TestBitVector/Test.py || die "Tests fail with ${EPYTHON}"
}

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="A pure-Python memory-efficient packed representation for bit arrays"
HOMEPAGE="https://engineering.purdue.edu/kak/dist/ https://pypi.python.org/pypi/BitVector"
SRC_URI="https://engineering.purdue.edu/kak/dist/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

python_test() {
	"${PYTHON}" TestBitVector/Test.py || die "Tests fail with ${EPYTHON}"
}

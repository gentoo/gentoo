# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_5} )

inherit distutils-r1

DESCRIPTION="A pure-Python memory-efficient packed representation for bit arrays"
HOMEPAGE="https://engineering.purdue.edu/kak/dist/ https://pypi.org/project/BitVector/"
SRC_URI="https://engineering.purdue.edu/kak/dist/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

python_test() {
	"${PYTHON}" TestBitVector/Test.py || die "Tests fail with ${EPYTHON}"
}

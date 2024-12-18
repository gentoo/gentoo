# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P=BitVector-${PV}
DESCRIPTION="A pure-Python memory-efficient packed representation for bit arrays"
HOMEPAGE="
	https://engineering.purdue.edu/kak/dist/
	https://pypi.org/project/BitVector/
"
SRC_URI="https://engineering.purdue.edu/kak/dist/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

python_test() {
	"${EPYTHON}" TestBitVector/Test.py || die "Tests fail with ${EPYTHON}"
}

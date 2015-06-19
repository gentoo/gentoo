# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/BitVector/BitVector-3.3.2.ebuild,v 1.5 2015/04/08 08:05:26 mgorny Exp $

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="A pure-Python memory-efficient packed representation for bit arrays"
HOMEPAGE="http://cobweb.ecn.purdue.edu/~kak/dist/ http://pypi.python.org/pypi/BitVector"
SRC_URI="http://cobweb.ecn.purdue.edu/~kak/dist/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="amd64 x86"

python_test() {
	"${PYTHON}" TestBitVector/Test.py || die "Tests fail with ${EPYTHON}"
}

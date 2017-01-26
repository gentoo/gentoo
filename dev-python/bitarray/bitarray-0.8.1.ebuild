# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=(python{2_7,3_4})

inherit distutils-r1

DESCRIPTION="efficient arrays of booleans -- C extension"
HOMEPAGE="https://github.com/ilanschnell/bitarray https://pypi.python.org/pypi/bitarray"
SRC_URI="mirror://pypi/b/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="PSF-2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

python_test() {
	"${PYTHON}" ${PN}/test_${PN}.py || die "Tests fail with ${EPYTHON}"
}

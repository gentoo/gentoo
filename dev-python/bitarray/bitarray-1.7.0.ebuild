# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="efficient arrays of booleans -- C extension"
HOMEPAGE="https://github.com/ilanschnell/bitarray https://pypi.org/project/bitarray/"
SRC_URI="mirror://pypi/b/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="PSF-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

python_test() {
	"${EPYTHON}" bitarray/test_bitarray.py -v || die "Tests fail with ${EPYTHON}"
}

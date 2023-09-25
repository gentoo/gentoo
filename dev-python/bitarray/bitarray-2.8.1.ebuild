# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Efficient arrays of booleans -- C extension"
HOMEPAGE="
	https://github.com/ilanschnell/bitarray/
	https://pypi.org/project/bitarray/
"

SLOT="0"
LICENSE="PSF-2"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux"

python_test() {
	"${EPYTHON}" bitarray/test_bitarray.py -v || die "Tests fail with ${EPYTHON}"
}

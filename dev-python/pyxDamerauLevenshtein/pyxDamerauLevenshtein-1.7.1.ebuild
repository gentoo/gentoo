# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Implements the Damerau-Levenshtein edit distance algorithm for Python in Cython"
HOMEPAGE="
	https://github.com/lanl/pyxDamerauLevenshtein/
	https://pypi.org/project/pyxDamerauLevenshtein/
"
SRC_URI="
	https://github.com/lanl/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

RDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_configure() {
	# recythonize
	cd pyxdameraulevenshtein || die
	cython -3 -f *.pyx || die
}

src_test() {
	rm -r pyxdameraulevenshtein || die
	distutils-r1_src_test
}

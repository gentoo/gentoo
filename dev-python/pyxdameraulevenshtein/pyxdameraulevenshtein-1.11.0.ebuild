# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/lanl/pyxDamerauLevenshtein
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Implements the Damerau-Levenshtein edit distance algorithm for Python in Cython"
HOMEPAGE="
	https://github.com/lanl/pyxDamerauLevenshtein/
	https://pypi.org/project/pyxDamerauLevenshtein/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~riscv ~x86"

BDEPEND="
	>=dev-python/cython-3.1[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
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

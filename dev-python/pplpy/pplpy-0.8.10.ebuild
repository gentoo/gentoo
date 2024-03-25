# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1

inherit distutils-r1 pypi

DESCRIPTION="Python bindings for the Parma Polyhedra Library (PPL)"
HOMEPAGE="
	https://github.com/sagemath/pplpy/
	https://pypi.org/project/pplpy/
"

# The file headers under ppl/ contain the "or later" bit
LICENSE="GPL-3+"
# API/ABI changes in point releases
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND="
	dev-libs/ppl
	dev-python/cysignals[${PYTHON_USEDEP}]
	>=dev-python/gmpy-2.1.0_beta1[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs/source

python_compile() {
	# Parallel build breaks the test suite somehow. This should be
	# reported upstream but first someone will need to figure out
	# how to reproduce it outside of Gentoo.
	distutils-r1_python_compile -j 1
}

python_test(){
	"${EPYTHON}" tests/runtests.py || die
}

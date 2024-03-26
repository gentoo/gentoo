# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

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
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
"

python_compile_all() {
	rm -r ppl || die
	use doc && build_sphinx docs/source
}

python_test(){
	"${EPYTHON}" tests/runtests.py || die
}

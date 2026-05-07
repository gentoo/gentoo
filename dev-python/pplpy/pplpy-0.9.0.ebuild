# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=meson-python
PYTHON_COMPAT=( python3_{12..14} )

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
KEYWORDS="~amd64 ~riscv"
IUSE="doc"

DEPEND="
	dev-libs/gmp:=[cxx]
	dev-libs/ppl:=
	dev-python/cysignals[${PYTHON_USEDEP}]
	>=dev-python/gmpy2-2.2.0[${PYTHON_USEDEP}]
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

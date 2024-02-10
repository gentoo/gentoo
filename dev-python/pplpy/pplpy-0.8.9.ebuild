# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1

inherit distutils-r1 pypi

DESCRIPTION="Python bindings for the Parma Polyhedra Library (PPL)"
HOMEPAGE="https://pypi.org/project/pplpy/
	https://github.com/sagemath/pplpy"

# The file headers under ppl/ contain the "or later" bit
LICENSE="GPL-3+"

# API/ABI changes in point releases
SLOT="0/${PV}"
KEYWORDS="amd64"
IUSE="doc"

DEPEND="dev-libs/ppl
	dev-python/cysignals[${PYTHON_USEDEP}]
	dev-python/gmpy[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
BDEPEND="dev-python/cython[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

python_compile() {
	# Parallel build breaks the test suite somehow. This should be
	# reported upstream but first someone will need to figure out
	# how to reproduce it outside of Gentoo.
	distutils-r1_python_compile -j 1
}

python_compile_all() {
	use doc && emake -C docs html
}

python_install_all(){
	use doc && local HTML_DOCS=( docs/build/html/. )
	distutils-r1_python_install_all
}

python_test(){
	"${EPYTHON}" setup.py test || die
}

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=standalone
DISTUTILS_EXT=1

inherit distutils-r1 pypi

DESCRIPTION="Cython interface to PARI"
HOMEPAGE="https://github.com/sagemath/cypari2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="sci-mathematics/pari[gmp,doc]
	dev-python/cysignals[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-python/cython-3[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}/${P}-regen-bindings-for-each-python.patch" )

python_test(){
	cd "${S}"/tests || die
	"${EPYTHON}" rundoctest.py || die
}

python_install() {
	distutils-r1_python_install
	python_optimize
}

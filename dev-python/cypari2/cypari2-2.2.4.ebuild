# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_USE_PEP517=meson-python
DISTUTILS_EXT=1

inherit distutils-r1 pypi

DESCRIPTION="Cython interface to PARI"
HOMEPAGE="https://github.com/sagemath/cypari2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

DEPEND=">=sci-mathematics/pari-2.17.1:=[gmp,doc]
	dev-python/cysignals[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-python/cython-3[${PYTHON_USEDEP}]"

src_prepare(){
	default

	# rename cypari2.py to cypari2.pc.in
	mv cypari2/cypari2.py.in cypari2/cypari2.pc.in || die
	sed -e "s:cypari2.py:cypari2.pc:g" -i cypari2/meson.build || die
}

python_test(){
	cd "${S}"/tests || die
	"${EPYTHON}" rundoctest.py || die
}

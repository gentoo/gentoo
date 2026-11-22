# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{13..15} )
DISTUTILS_USE_PEP517=meson-python
DISTUTILS_EXT=1

inherit distutils-r1 pypi

DESCRIPTION="Cython interface to PARI"
HOMEPAGE="https://github.com/sagemath/cypari2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

DEPEND=">=sci-mathematics/pari-2.17.1:=[gmp(+),doc]
	dev-python/cysignals[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-python/cython-3[${PYTHON_USEDEP}]"

python_test(){
	cd "${S}"/tests || die
	"${EPYTHON}" rundoctest.py || die
}

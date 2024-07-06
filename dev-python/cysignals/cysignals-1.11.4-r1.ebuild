# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Interrupt and signal handling for Cython"
HOMEPAGE="
	https://github.com/sagemath/cysignals/
	https://pypi.org/project/cysignals/
"

# setup.py has "or later"
LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64"

DEPEND="
	sci-mathematics/pari:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=dev-python/cython-3.0.0[${PYTHON_USEDEP}]
"

PATCHES=(
	# https://github.com/sagemath/cysignals/pull/204
	"${FILESDIR}/${P}-helper.patch"
)

python_test(){
	local -x PATH="${BUILD_DIR}/scripts:${PATH}"
	"${EPYTHON}" -B rundoctests.py src/cysignals/*.pyx || die
}

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_PN="gmpy2"
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Python bindings for GMP, MPC, MPFR and MPIR libraries"
HOMEPAGE="
	https://github.com/aleaxit/gmpy/
	https://pypi.org/project/gmpy2/
"

LICENSE="LGPL-3+"
SLOT="2"

DEPEND="
	>=dev-libs/mpc-1.0.2:=
	>=dev-libs/mpfr-3.1.2:=
	dev-libs/gmp:0=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	test? (
		dev-python/mpmath[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( hypothesis )
EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	rm -rf gmpy2 || die
	epytest
}

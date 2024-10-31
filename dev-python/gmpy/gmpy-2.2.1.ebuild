# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_PN="gmpy2"
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Python bindings for GMP, MPC, MPFR and MPIR libraries"
HOMEPAGE="
	https://github.com/aleaxit/gmpy/
	https://pypi.org/project/gmpy2/
"

LICENSE="LGPL-3+"
SLOT="2"
KEYWORDS="amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

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
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/mpmath[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	rm -rf gmpy2 || die

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi virtualx

DESCRIPTION="Python library for arbitrary-precision floating-point arithmetic"
HOMEPAGE="
	https://mpmath.org/
	https://github.com/mpmath/mpmath/
	https://pypi.org/project/mpmath/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="gmp matplotlib"

RDEPEND="
	gmp? ( dev-python/gmpy[${PYTHON_USEDEP}] )
	matplotlib? ( dev-python/matplotlib[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	"${EPYTHON}" mpmath/tests/runtests.py -local || die "Tests failed with ${EPYTHON}"
}

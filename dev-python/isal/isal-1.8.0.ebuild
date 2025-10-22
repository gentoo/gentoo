# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Faster zlib and gzip via the ISA-L library"
HOMEPAGE="
	https://github.com/pycompression/python-isal/
	https://pypi.org/project/isal/
"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

DEPEND="
	dev-libs/isa-l:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/test[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
# incompatible with xdist
distutils_enable_tests pytest

export PYTHON_ISAL_LINK_DYNAMIC=1

python_test() {
	epytest tests
}

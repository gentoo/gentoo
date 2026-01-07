# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/twisted/cython-test-exception-raiser
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="A trivial extension that just raises an exception (for testing)"
HOMEPAGE="
	https://pypi.org/project/cython-test-exception-raiser/
	https://github.com/twisted/cython-test-exception-raiser/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ppc ppc64 ~riscv ~s390 ~sparc x86"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

distutils_enable_tests import-check

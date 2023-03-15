# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="A pyunit extension for dependency injection"
HOMEPAGE="
	https://launchpad.net/testscenarios/
	https://github.com/testing-cabal/testscenarios/
	https://pypi.org/project/testscenarios/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"

RDEPEND="
	dev-python/testtools[${PYTHON_USEDEP}]
	>=dev-python/pbr-0.11[${PYTHON_USEDEP}]
"

# using pytest for tests since unittest loader fails with py3.5+
BDEPEND="
	>=dev-python/pbr-0.11[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	testscenarios/tests/test_testcase.py
)

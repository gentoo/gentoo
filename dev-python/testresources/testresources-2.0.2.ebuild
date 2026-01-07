# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="A pyunit extension for managing expensive test resources"
HOMEPAGE="
	https://launchpad.net/testresources/
	https://github.com/testing-cabal/testresources/
	https://pypi.org/project/testresources/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	dev-python/pbr[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/pbr[${PYTHON_USEDEP}]
	test? (
		dev-python/testtools[${PYTHON_USEDEP}]
		dev-python/fixtures[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

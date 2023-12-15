# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="A parser for Python dependency files"
HOMEPAGE="
	https://github.com/pyupio/dparse
	https://pypi.org/project/dparse/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

distutils_enable_tests pytest

BDEPEND="
	test? (
		dev-python/pipenv[${PYTHON_USEDEP}]
	)
"

# Break circular dependency
PDEPEND="
	dev-python/pipenv[${PYTHON_USEDEP}]
"

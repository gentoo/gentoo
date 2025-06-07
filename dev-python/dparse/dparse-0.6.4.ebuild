# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="A parser for Python dependency files"
HOMEPAGE="
	https://github.com/pyupio/dparse
	https://pypi.org/project/dparse/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv"

# Break circular dependency
PDEPEND="
	dev-python/pipenv[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${PDEPEND}
	)
"

distutils_enable_tests pytest

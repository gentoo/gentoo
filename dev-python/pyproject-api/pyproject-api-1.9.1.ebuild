# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="API to interact with the python pyproject.toml based projects"
HOMEPAGE="
	https://github.com/tox-dev/pyproject-api/
	https://pypi.org/project/pyproject-api/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/packaging-25[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/hatch-vcs-0.3.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pytest-mock-3.11.1[${PYTHON_USEDEP}]
		>=dev-python/setuptools-70.1.0[${PYTHON_USEDEP}]
		>=dev-python/wheel-0.40.2[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Format your pyproject.toml file"
HOMEPAGE="
	https://github.com/tox-dev/pyproject-fmt/
	https://pypi.org/project/pyproject-fmt/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/natsort-8.3.1[${PYTHON_USEDEP}]
	>=dev-python/packaging-23.1[${PYTHON_USEDEP}]
	>=dev-python/tomlkit-0.11.8[${PYTHON_USEDEP}]
"
# tox is called as a subprocess, to get targets from tox.ini
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pytest-mock-3.10[${PYTHON_USEDEP}]
		dev-python/tox
	)
"

distutils_enable_tests pytest

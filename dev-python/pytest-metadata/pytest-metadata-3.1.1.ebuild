# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="A plugin for pytest that provides access to test session metadata"
HOMEPAGE="
	https://github.com/pytest-dev/pytest-metadata/
	https://pypi.org/project/pytest-metadata/
"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="
	>=dev-python/pytest-7.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/hatch-vcs-0.3[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

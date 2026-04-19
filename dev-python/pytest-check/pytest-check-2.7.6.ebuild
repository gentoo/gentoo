# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="pytest plugin that allows multiple failures per test"
HOMEPAGE="
	https://github.com/okken/pytest-check/
	https://pypi.org/project/pytest-check/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	>=dev-python/pytest-7.0.0[${PYTHON_USEDEP}]
"

EPYTEST_PLUGIN_LOAD_VIA_ENV=1
EPYTEST_PLUGINS=( "${PN}" )
distutils_enable_tests pytest

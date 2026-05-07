# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/pytest-dev/pytest-repeat
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="pytest plugin for repeating tests"
HOMEPAGE="
	https://github.com/pytest-dev/pytest-repeat/
	https://pypi.org/project/pytest-repeat/
"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( "${PN}" )
EPYTEST_PLUGIN_LOAD_VIA_ENV=1
distutils_enable_tests pytest

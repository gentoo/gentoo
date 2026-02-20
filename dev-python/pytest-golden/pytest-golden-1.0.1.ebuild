# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/oprypin/pytest-golden
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Plugin for pytest that offloads expected outputs to data files"
HOMEPAGE="
	https://github.com/oprypin/pytest-golden/
	https://pypi.org/project/pytest-golden/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv x86"

RDEPEND="
	>=dev-python/pytest-6.1.2[${PYTHON_USEDEP}]
	>=dev-python/ruamel-yaml-0.16.12[${PYTHON_USEDEP}]
	<dev-python/ruamel-yaml-1.0[${PYTHON_USEDEP}]
	>=dev-python/testfixtures-6.15.0[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( "${PN}" )
EPYTEST_PLUGIN_LOAD_VIA_ENV=1
distutils_enable_tests pytest

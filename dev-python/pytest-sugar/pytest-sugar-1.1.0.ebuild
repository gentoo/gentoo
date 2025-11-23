# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Plugin that changes the default look and feel of pytest"
HOMEPAGE="
	https://github.com/Teemu/pytest-sugar/
	https://pypi.org/project/pytest-sugar/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/pytest-6.2.0[${PYTHON_USEDEP}]
	>=dev-python/termcolor-2.1.0[${PYTHON_USEDEP}]
"

EPYTEST_PLUGIN_LOAD_VIA_ENV=1
EPYTEST_PLUGINS=( "${PN}" pytest-{rerunfailures,xdist} )
distutils_enable_tests pytest

# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYPI_VERIFY_REPO=https://github.com/noirbizarre/pytest-gitconfig
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Provide a Git config sandbox for testing"
HOMEPAGE="
	https://github.com/noirbizarre/pytest-gitconfig/
	https://pypi.org/project/pytest-gitconfig/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

RDEPEND="
	>=dev-python/pytest-7.1.2[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( "${PN}" )
EPYTEST_PLUGIN_LOAD_VIA_ENV=1
distutils_enable_tests pytest

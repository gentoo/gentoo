# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1 pypi

DESCRIPTION="Griffe extension for inheriting docstrings"
HOMEPAGE="
	https://github.com/mkdocstrings/griffe-inherited-docstrings/
	https://pypi.org/project/griffe-inherited-docstrings/
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

RDEPEND="
	>=dev-python/griffe-1.14[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

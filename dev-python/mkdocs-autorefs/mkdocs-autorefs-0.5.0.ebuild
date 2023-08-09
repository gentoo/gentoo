# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=pdm-backend

inherit distutils-r1 pypi

DESCRIPTION="Automatically link across pages in MkDoc"
HOMEPAGE="
	https://mkdocstrings.github.io/autorefs/
	https://github.com/mkdocstrings/autorefs/
	https://pypi.org/project/mkdocs-autorefs/
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="
	dev-python/markdown[${PYTHON_USEDEP}]
	dev-python/mkdocs[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

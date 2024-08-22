# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} pypy3 )
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
KEYWORDS="~amd64 ~arm64 ~riscv"

RDEPEND="
	>=dev-python/markdown-3.3[${PYTHON_USEDEP}]
	>=dev-python/markupsafe-2.0.1[${PYTHON_USEDEP}]
	>=dev-python/mkdocs-1.1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/pygments-2.16[${PYTHON_USEDEP}]
		>=dev-python/pymdown-extensions-10.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

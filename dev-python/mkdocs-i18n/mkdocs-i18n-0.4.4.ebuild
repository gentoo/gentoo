# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="MkDocs i18n plugin"
HOMEPAGE="
	https://gitlab.com/mkdocs-i18n/mkdocs-i18n/-/tree/main
	https://pypi.org/project/mkdocs-i18n/
"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~riscv x86"

RDEPEND="
	>=dev-python/mkdocs-1.1[${PYTHON_USEDEP}]
	dev-python/mkdocs-material[${PYTHON_USEDEP}]
"

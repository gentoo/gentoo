# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Custom alterations based on Mkdocs-Material"
HOMEPAGE="
	https://github.com/facelessuser/mkdocs_pymdownx_material_extras/
	https://pypi.org/project/mkdocs-pymdownx-material-extras/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~riscv x86"

RDEPEND="
	>=dev-python/mkdocs-material-8.3.3[${PYTHON_USEDEP}]
"

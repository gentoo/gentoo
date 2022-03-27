# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Custom alterations based on Mkdocs-Material"
HOMEPAGE="
	https://github.com/facelessuser/mkdocs_pymdownx_material_extras
	https://pypi.org/project/mkdocs-pymdownx-material-extras"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

RDEPEND="
	>=dev-python/mkdocs-material-5.0.2[${PYTHON_USEDEP}]
"

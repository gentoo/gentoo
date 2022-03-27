# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="MkDocs i18n plugin"
HOMEPAGE="
	https://gitlab.com/mkdocs-i18n/mkdocs-i18n/-/tree/main
	https://pypi.org/project/mkdocs-i18n/
"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

RDEPEND="
	>=dev-python/mkdocs-1.1[${PYTHON_USEDEP}]
	dev-python/mkdocs-material[${PYTHON_USEDEP}]
"

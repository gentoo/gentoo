# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="A Material Design theme for MkDocs"
HOMEPAGE="
	https://github.com/squidfunk/mkdocs-material
	https://pypi.org/project/mkdocs-material
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/markdown-3.2[${PYTHON_USEDEP}]
	>=dev-python/mkdocs-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.4[${PYTHON_USEDEP}]
	>=dev-python/pymdown-extensions-6.3[${PYTHON_USEDEP}]"

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="An MkDocs plugin to minify HTML and/or JS files prior to being written to disk"
HOMEPAGE="
	https://github.com/byrnereese/mkdocs-minify-plugin
	https://pypi.org/project/mkdocs-minify-plugin/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="
	>=dev-python/csscompressor-0.9.5[${PYTHON_USEDEP}]
	>=dev-python/mkdocs-1.0.4[${PYTHON_USEDEP}]
	>=app-text/htmlmin-0.1.4[${PYTHON_USEDEP}]
	>=dev-python/jsmin-2.2.2[${PYTHON_USEDEP}]
"

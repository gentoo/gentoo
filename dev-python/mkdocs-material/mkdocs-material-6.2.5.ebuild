# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

DOCS_BUILDER="mkdocs"
DOCS_DEPEND="
	dev-python/mkdocs-minify-plugin
	dev-python/mkdocs-redirects
"

inherit distutils-r1 docs

DESCRIPTION="A Material Design theme for MkDocs"
HOMEPAGE="
	https://github.com/squidfunk/mkdocs-material
	https://pypi.org/project/mkdocs-material
"
SRC_URI="https://github.com/squidfunk/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/markdown-3.2[${PYTHON_USEDEP}]
	>=dev-python/mkdocs-1.1[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.4[${PYTHON_USEDEP}]
	>=dev-python/pymdown-extensions-7.0[${PYTHON_USEDEP}]
	>=dev-python/mkdocs-material-extensions-1.0[${PYTHON_USEDEP}]
"

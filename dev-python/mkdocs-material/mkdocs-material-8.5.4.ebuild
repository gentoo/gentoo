# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{8..11} )

DOCS_BUILDER="mkdocs"
DOCS_DEPEND="
	dev-python/mkdocs-material-extensions
	dev-python/mkdocs-minify-plugin
	dev-python/mkdocs-redirects
"

inherit distutils-r1 docs

DESCRIPTION="A Material Design theme for MkDocs"
HOMEPAGE="
	https://github.com/squidfunk/mkdocs-material/
	https://pypi.org/project/mkdocs-material/
"
SRC_URI="
	https://github.com/squidfunk/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="
	>=dev-python/jinja-3.0.2[${PYTHON_USEDEP}]
	>=dev-python/markdown-3.2[${PYTHON_USEDEP}]
	>=dev-python/mkdocs-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.12[${PYTHON_USEDEP}]
	>=dev-python/pymdown-extensions-9.4[${PYTHON_USEDEP}]
"

# mkdocs-material-extensions depends on mkdocs-material creating a circular dep
PDEPEND=">=dev-python/mkdocs-material-extensions-1.0.3[${PYTHON_USEDEP}]"

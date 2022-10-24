# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="An MkDocs plugin to minify HTML and/or JS files prior to being written to disk"
HOMEPAGE="
	https://github.com/byrnereese/mkdocs-minify-plugin
	https://pypi.org/project/mkdocs-minify-plugin/
"
SRC_URI="
	https://github.com/byrnereese/mkdocs-minify-plugin/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="
	>=dev-python/csscompressor-0.9.5[${PYTHON_USEDEP}]
	>=dev-python/mkdocs-1.4.1[${PYTHON_USEDEP}]
	>=app-text/htmlmin-0.1.12[${PYTHON_USEDEP}]
	>=dev-python/jsmin-3.0.1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		~dev-python/mkdocs-minify-plugin-${PV}[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

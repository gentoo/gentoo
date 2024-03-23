# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1

DESCRIPTION="A MkDocs plugin that validates URLs in rendered HTML files"
HOMEPAGE="
	https://github.com/manuzhang/mkdocs-htmlproofer-plugin/
	https://pypi.org/project/mkdocs-htmlproofer-plugin/
"
# No tests in PyPI tarballs
SRC_URI="
	https://github.com/manuzhang/mkdocs-htmlproofer-plugin/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

RDEPEND="
	dev-python/beautifulsoup4[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	>=dev-python/mkdocs-1.4.0[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

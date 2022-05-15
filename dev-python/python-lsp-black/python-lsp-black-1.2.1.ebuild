# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Black plugin for the Python LSP Server"
HOMEPAGE="
	https://github.com/python-lsp/python-lsp-black/
	https://pypi.org/project/python-lsp-black/
"
SRC_URI="
	https://github.com/python-lsp/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=dev-python/python-lsp-server-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/black-22.3.0[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/toml[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1

DESCRIPTION="Black plugin for the Python LSP Server"
HOMEPAGE="https://github.com/python-lsp/python-lsp-black
	https://pypi.org/project/python-lsp-black/"
SRC_URI="https://github.com/python-lsp/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/python-lsp-server[${PYTHON_USEDEP}]
	>=dev-python/black-19[${PYTHON_USEDEP}]
"

distutils_enable_tests --install pytest

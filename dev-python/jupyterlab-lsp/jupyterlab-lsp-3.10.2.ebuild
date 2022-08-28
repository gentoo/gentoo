# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Coding assistance for JupyterLab with Language Server Protocol"
HOMEPAGE="https://github.com/jupyter-lsp/jupyterlab-lsp"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/jupyterlab-3.1.0[${PYTHON_USEDEP}]
	<dev-python/jupyterlab-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/jupyter-lsp-1.4.0[${PYTHON_USEDEP}]
"

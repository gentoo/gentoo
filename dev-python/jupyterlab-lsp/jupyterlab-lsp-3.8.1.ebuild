# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Coding assistance for JupyterLab with Language Server Protocol"
HOMEPAGE="https://github.com/krassowski/jupyterlab-lsp"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/jupyterlab-3.0.0[${PYTHON_USEDEP}]
	<dev-python/jupyterlab-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/jupyter-lsp-1.4.0[${PYTHON_USEDEP}]
"

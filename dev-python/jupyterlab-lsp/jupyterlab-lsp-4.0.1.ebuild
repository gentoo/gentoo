# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
inherit distutils-r1 pypi

DESCRIPTION="Coding assistance for JupyterLab with Language Server Protocol"
HOMEPAGE="https://github.com/jupyter-lsp/jupyterlab-lsp"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/jupyterlab-3.6.0[${PYTHON_USEDEP}]
	<dev-python/jupyterlab-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/jupyter-lsp-2.0.0[${PYTHON_USEDEP}]
"

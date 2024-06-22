# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=jupyter
PYTHON_COMPAT=( pypy3 python3_{10..12} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi

DESCRIPTION="Jupyter interactive widgets for JupyterLab"
HOMEPAGE="
	https://ipython.org/
	https://pypi.org/project/jupyterlab-widgets/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 arm arm64 ~loong ~riscv x86"

BDEPEND="
	>=dev-python/jupyterlab-4.1.8[${PYTHON_USEDEP}]
	dev-python/jupyter-packaging[${PYTHON_USEDEP}]
"

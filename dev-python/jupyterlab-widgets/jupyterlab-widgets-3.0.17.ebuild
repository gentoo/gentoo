# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi

DESCRIPTION="Jupyter interactive widgets for JupyterLab"
HOMEPAGE="
	https://ipython.org/
	https://pypi.org/project/jupyterlab-widgets/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

BDEPEND="
	dev-python/hatch-jupyter-builder[${PYTHON_USEDEP}]
"

distutils_enable_tests import-check

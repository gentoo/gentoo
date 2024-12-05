# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Jupyter metapackage. Install all the Jupyter components in one go"
HOMEPAGE="https://jupyter.org"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

RDEPEND="
	dev-python/notebook[${PYTHON_USEDEP}]
	dev-python/jupyter-console[${PYTHON_USEDEP}]
	dev-python/nbconvert[${PYTHON_USEDEP}]
	dev-python/ipykernel[${PYTHON_USEDEP}]
	dev-python/ipywidgets[${PYTHON_USEDEP}]
	dev-python/jupyterlab[${PYTHON_USEDEP}]
"

# TODO: package sphinxext.rediraffe
# distutils_enable_sphinx docs/source dev-python/sphinx-rtd-theme

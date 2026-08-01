# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi xdg

DESCRIPTION="JupyterLab build tools"
HOMEPAGE="
	https://jupyter.org/
	https://github.com/jupyterlab/jupyter-builder
	https://pypi.org/project/jupyter-builder/
"

LICENSE="BSD MIT ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

RDEPEND="
	!<dev-python/jupyterlab-4.6.0
	dev-python/jupyter-core[${PYTHON_USEDEP}]
	dev-python/traitlets[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/jinja2-time[${PYTHON_USEDEP}]
	)
"

EPYTEST_IGNORE=(
	# TODO: package copier
	tests/test_tpl.py
)

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

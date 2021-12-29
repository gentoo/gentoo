# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Server components for JupyterLab and JupyterLab like applications"
HOMEPAGE="https://jupyter.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

# TODO: package openapi et al
RESTRICT="test"

RDEPEND="
	dev-python/Babel[${PYTHON_USEDEP}]
	>=dev-python/entrypoints-0.2.2[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.10[${PYTHON_USEDEP}]
	dev-python/json5[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-3.0.1[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/jupyter_server[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
# TODO: package myst_parser
#distutils_enable_sphinx docs/source dev-python/pydata-sphinx-theme

python_prepare_all() {
	# Do not depend on pytest-cov
	sed -i -e '/addopts/d' pyproject.toml || die

	# Defining 'pytest_plugins' in a non-top-level conftest is no longer supported:
	mv ${PN}/tests/conftest.py . || die

	distutils-r1_python_prepare_all
}

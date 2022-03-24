# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools
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
	>=dev-python/jinja-3.0.3[${PYTHON_USEDEP}]
	dev-python/json5[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-3.0.1[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	>=dev-python/jupyter_server-1.8[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
# TODO: package autodoc_traits
#distutils_enable_sphinx docs/source dev-python/pydata-sphinx-theme dev-python/myst_parser

python_prepare_all() {
	# Do not depend on pytest-cov
	sed -i -e '/addopts/d' pyproject.toml || die

	distutils-r1_python_prepare_all
}

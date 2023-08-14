# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=hatchling

inherit distutils-r1 pypi

DESCRIPTION="Server components for JupyterLab and JupyterLab like applications"
HOMEPAGE="
	https://jupyter.org/
	https://github.com/jupyterlab/jupyterlab_server/
	https://pypi.org/project/jupyterlab-server/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="
	>=dev-python/Babel-2.10[${PYTHON_USEDEP}]
	>=dev-python/jinja-3.0.3[${PYTHON_USEDEP}]
	>=dev-python/json5-0.9.0[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-3.0.1[${PYTHON_USEDEP}]
	>=dev-python/packaging-21.3[${PYTHON_USEDEP}]
	>=dev-python/requests-2.28[${PYTHON_USEDEP}]
	>=dev-python/jupyter-server-1.21[${PYTHON_USEDEP}]
	<dev-python/jupyter-server-3[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/ipykernel[${PYTHON_USEDEP}]
		dev-python/jupyter-server[${PYTHON_USEDEP}]
		<dev-python/openapi-core-0.17[${PYTHON_USEDEP}]
		>=dev-python/openapi-core-0.16.1[${PYTHON_USEDEP}]
		<dev-python/openapi-spec-validator-0.6[${PYTHON_USEDEP}]
		>=dev-python/openapi-spec-validator-0.5.1[${PYTHON_USEDEP}]
		dev-python/pytest-jupyter[${PYTHON_USEDEP}]
		dev-python/pytest-tornasync[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		dev-python/ruamel-yaml[${PYTHON_USEDEP}]
		dev-python/strict-rfc3339[${PYTHON_USEDEP}]
		dev-python/requests-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
# TODO: package autodoc_traits
#distutils_enable_sphinx docs/source dev-python/pydata-sphinx-theme dev-python/myst-parser

python_test() {
	local EPYTEST_IGNORE=(
		tests/test_translation_api.py
	)

	EPYTEST_DESELECT=(
		# Fails if terminal not available
		tests/test_labapp.py::test_page_config
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p pytest_tornasync.plugin
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=hatchling

inherit distutils-r1

DESCRIPTION="Server components for JupyterLab and JupyterLab like applications"
HOMEPAGE="
	https://jupyter.org/
	https://github.com/jupyterlab/jupyterlab_server/
	https://pypi.org/project/jupyterlab-server/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/Babel[${PYTHON_USEDEP}]
	>=dev-python/jinja-3.0.3[${PYTHON_USEDEP}]
	dev-python/json5[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-3.0.1[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	>=dev-python/jupyter_server-1.8[${PYTHON_USEDEP}]
	<dev-python/jupyter_server-3[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/importlib_metadata-4.8.3[${PYTHON_USEDEP}]
	' 3.8 3.9)
"

BDEPEND="
	test? (
		dev-python/ipykernel[${PYTHON_USEDEP}]
		dev-python/jupyter_server[${PYTHON_USEDEP}]
		>=dev-python/openapi-core-0.14.2[${PYTHON_USEDEP}]
		<dev-python/openapi-core-0.15[${PYTHON_USEDEP}]
		dev-python/openapi-spec-validator[${PYTHON_USEDEP}]
		dev-python/pytest-tornasync[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		dev-python/ruamel-yaml[${PYTHON_USEDEP}]
		dev-python/strict-rfc3339[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
# TODO: package autodoc_traits
#distutils_enable_sphinx docs/source dev-python/pydata-sphinx-theme dev-python/myst_parser

python_test() {
	local EPYTEST_IGNORE=(
		tests/test_translation_api.py
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p pytest_tornasync.plugin
}

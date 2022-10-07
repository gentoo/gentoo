# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=jupyter
inherit distutils-r1

DESCRIPTION="JupyterLab computational environment"
HOMEPAGE="https://jupyter.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD MIT GPL-3 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="dev-python/jupyter_packaging[${PYTHON_USEDEP}]"

RDEPEND="
	dev-python/ipython[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/jupyter_core[${PYTHON_USEDEP}]
	>=dev-python/jupyterlab_server-2.10[${PYTHON_USEDEP}]
	>=dev-python/jupyter_server-1.16[${PYTHON_USEDEP}]
	>=dev-python/nbclassic-0.2[${PYTHON_USEDEP}]
	<dev-python/notebook-7[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.1[${PYTHON_USEDEP}]
	>=dev-python/tornado-6.1[${PYTHON_USEDEP}]
	net-libs/nodejs
"

BDEPEND="test? (
	dev-python/check-manifest[${PYTHON_USEDEP}]
	dev-python/ipykernel[${PYTHON_USEDEP}]
	dev-python/jupyterlab_server[${PYTHON_USEDEP}]
	dev-python/openapi-core[${PYTHON_USEDEP}]
	dev-python/openapi-spec-validator[${PYTHON_USEDEP}]
	dev-python/pytest-console-scripts[${PYTHON_USEDEP}]
	dev-python/pytest-tornasync[${PYTHON_USEDEP}]
	dev-python/pytest-timeout[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	dev-python/requests-cache[${PYTHON_USEDEP}]
	dev-python/strict-rfc3339[${PYTHON_USEDEP}]
	dev-python/virtualenv[${PYTHON_USEDEP}]
)"

EPYTEST_DESELECT=(
	# These tests call npm and want internet
	jupyterlab/tests/test_jupyterlab.py::TestExtension::test_uninstall_core_extension
	jupyterlab/tests/test_jupyterlab.py::TestExtension::test_install_and_uninstall_pinned_folder
	jupyterlab/tests/test_jupyterlab.py::TestExtension::test_install_and_uninstall_pinned
	jupyterlab/tests/test_jupyterlab.py::TestExtension::test_build_custom_minimal_core_config
	jupyterlab/tests/test_jupyterlab.py::TestExtension::test_build_custom
	jupyterlab/tests/test_jupyterlab.py::TestExtension::test_build_check
	jupyterlab/tests/test_jupyterlab.py::TestExtension::test_build
	jupyterlab/tests/test_build_api.py::TestBuildAPI::test_clear
	jupyterlab/tests/test_build_api.py::TestBuildAPI::test_build
)

distutils_enable_tests pytest
# TODO: package sphinx_copybutton
#distutils_enable_sphinx docs/source dev-python/sphinx_rtd_theme dev-python/myst_parser

python_install_all() {
	distutils-r1_python_install_all
	mv "${ED}/usr/etc" "${ED}/etc" || die
}

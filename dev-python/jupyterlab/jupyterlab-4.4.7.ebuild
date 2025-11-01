# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..13} )

inherit distutils-r1 pypi xdg

DESCRIPTION="JupyterLab computational environment"
HOMEPAGE="
	https://jupyter.org/
	https://github.com/jupyterlab/jupyterlab/
	https://pypi.org/project/jupyterlab/
"

LICENSE="BSD MIT GPL-3 Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc64 ~riscv x86"

RDEPEND="
	>=dev-python/async-lru-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.28.0[${PYTHON_USEDEP}]
	>=dev-python/ipykernel-6.5.0[${PYTHON_USEDEP}]
	>=dev-python/jinja2-3.0.3[${PYTHON_USEDEP}]
	dev-python/jupyter-core[${PYTHON_USEDEP}]
	>=dev-python/jupyter-lsp-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/jupyter-server-2.4.0[${PYTHON_USEDEP}]
	<dev-python/jupyter-server-3[${PYTHON_USEDEP}]
	>=dev-python/jupyterlab-server-2.27.1[${PYTHON_USEDEP}]
	<dev-python/jupyterlab-server-3[${PYTHON_USEDEP}]
	>=dev-python/notebook-shim-0.2[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/setuptools-41.1.0[${PYTHON_USEDEP}]
	>=dev-python/tornado-6.2.0[${PYTHON_USEDEP}]
	dev-python/traitlets[${PYTHON_USEDEP}]
	net-libs/nodejs[npm]
"

BDEPEND="
	dev-python/hatch-jupyter-builder[${PYTHON_USEDEP}]
	test? (
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/requests-cache[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
	)
"

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

EPYTEST_IGNORE=(
	jupyterlab/tests/test_announcements.py
)

EPYTEST_PLUGINS=( pytest-{console-scripts,jupyter,tornasync,timeout} )
distutils_enable_tests pytest
# TODO: package sphinx_copybutton
#distutils_enable_sphinx docs/source dev-python/sphinx-rtd-theme dev-python/myst-parser

python_install_all() {
	distutils-r1_python_install_all
	mv "${ED}/usr/etc" "${ED}/etc" || die
}

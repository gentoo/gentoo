# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_NO_NORMALIZE=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="Multi-Language Server WebSocket proxy for Jupyter Notebook/Lab"
HOMEPAGE="https://github.com/krassowski/jupyterlab-lsp"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/entrypoints[${PYTHON_USEDEP}]
	>=dev-python/jupyter-server-1.1.2[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/importlib-metadata-4.8.3[${PYTHON_USEDEP}]
	' 3.9)
"

EPYTEST_DESELECT=(
	# Not packaged
	"jupyter_lsp/tests/test_listener.py::test_listeners[bash-language-server]"
	"jupyter_lsp/tests/test_listener.py::test_listeners[dockerfile-language-server-nodejs]"
	"jupyter_lsp/tests/test_listener.py::test_listeners[pylsp]"
	"jupyter_lsp/tests/test_listener.py::test_listeners[sql-language-server]"
	"jupyter_lsp/tests/test_listener.py::test_listeners[typescript-language-server]"
	"jupyter_lsp/tests/test_listener.py::test_listeners[unified-language-server]"
	"jupyter_lsp/tests/test_listener.py::test_listeners[vscode-css-languageserver-bin]"
	"jupyter_lsp/tests/test_listener.py::test_listeners[vscode-html-languageserver-bin]"
	"jupyter_lsp/tests/test_listener.py::test_listeners[vscode-json-languageserver-bin]"
	"jupyter_lsp/tests/test_listener.py::test_listeners[yaml-language-server]"
	"jupyter_lsp/tests/test_session.py::test_start_known[bash-language-server]"
	"jupyter_lsp/tests/test_session.py::test_start_known[dockerfile-language-server-nodejs]"
	"jupyter_lsp/tests/test_session.py::test_start_known[pylsp]"
	"jupyter_lsp/tests/test_session.py::test_start_known[sql-language-server]"
	"jupyter_lsp/tests/test_session.py::test_start_known[typescript-language-server]"
	"jupyter_lsp/tests/test_session.py::test_start_known[unified-language-server]"
	"jupyter_lsp/tests/test_session.py::test_start_known[vscode-css-languageserver-bin]"
	"jupyter_lsp/tests/test_session.py::test_start_known[vscode-html-languageserver-bin]"
	"jupyter_lsp/tests/test_session.py::test_start_known[vscode-json-languageserver-bin]"
	"jupyter_lsp/tests/test_session.py::test_start_known[yaml-language-server]"
)

distutils_enable_tests pytest

python_prepare_all() {
	# Do not depend on pytest-cov or flake8
	sed -i -e '/--cov/d' -e '/--flake8/d' setup.cfg || die
	# R lsp server not packaged
	sed -i -e 's:test_r_package_detection:_&:' \
		jupyter_lsp/tests/test_detect.py || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all
	mv "${ED}/usr/etc" "${ED}/etc" || die
}

pkg_postinst() {
	optfeature "Language server for Python" dev-python/python-lsp-server
}

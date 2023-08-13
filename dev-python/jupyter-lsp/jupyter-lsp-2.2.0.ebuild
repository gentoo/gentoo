# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_NO_NORMALIZE=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="Multi-Language Server WebSocket proxy for Jupyter Notebook/Lab"
HOMEPAGE="
	https://github.com/jupyter-lsp/jupyterlab-lsp
	https://pypi.org/project/jupyter-lsp/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

RDEPEND="
	dev-python/entrypoints[${PYTHON_USEDEP}]
	>=dev-python/jupyter-server-1.1.2[${PYTHON_USEDEP}]
"

EPYTEST_DESELECT=(
	# Not packaged
	jupyter_lsp/tests/test_detect.py::test_r_package_detection
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

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all
	mv "${ED}/usr/etc" "${ED}/etc" || die
}

pkg_postinst() {
	optfeature "Language server for Python" dev-python/python-lsp-server
}

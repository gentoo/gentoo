# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="Multi-Language Server WebSocket proxy for Jupyter Notebook/Lab"
HOMEPAGE="https://github.com/krassowski/jupyterlab-lsp"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

# TODO: Find out what is going on here
# asyncio.exceptions.TimeoutError
RESTRICT="test"

RDEPEND="
	dev-python/entrypoints[${PYTHON_USEDEP}]
	>=dev-python/jupyter-server-1.1.2[${PYTHON_USEDEP}]
"

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

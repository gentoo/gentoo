# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=jupyter

inherit distutils-r1 xdg-utils

DESCRIPTION="Jupyter Notebook as a Jupyter Server Extension"
HOMEPAGE="
	https://jupyter.org/
	https://github.com/jupyter/nbclassic/
	https://pypi.org/project/nbclassic/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/argon2-cffi[${PYTHON_USEDEP}]
	dev-python/ipykernel[${PYTHON_USEDEP}]
	dev-python/ipython_genutils[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	>=dev-python/jupyter_client-6.1.1[${PYTHON_USEDEP}]
	>=dev-python/jupyter_core-4.6.1[${PYTHON_USEDEP}]
	>=dev-python/jupyter_server-1.17.0[${PYTHON_USEDEP}]
	>=dev-python/nbconvert-5[${PYTHON_USEDEP}]
	dev-python/nbformat[${PYTHON_USEDEP}]
	>=dev-python/nest_asyncio-1.5[${PYTHON_USEDEP}]
	>=dev-python/notebook_shim-0.1.0[${PYTHON_USEDEP}]
	dev-python/prometheus_client[${PYTHON_USEDEP}]
	>=dev-python/send2trash-1.8.0[${PYTHON_USEDEP}]
	>=dev-python/terminado-0.8.3[${PYTHON_USEDEP}]
	>=dev-python/tornado-6.1[${PYTHON_USEDEP}]
	>=dev-python/traitlets-4.2.1[${PYTHON_USEDEP}]

	<dev-python/notebook-7[${PYTHON_USEDEP}]
"

# dev-python/nbval is missing impls
BDEPEND="
	test? (
		dev-python/pytest_jupyter[${PYTHON_USEDEP}]
		dev-python/pytest-tornasync[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/requests-unixsocket[${PYTHON_USEDEP}]
		dev-python/testpath[${PYTHON_USEDEP}]
	)
	doc? (
		virtual/pandoc
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx docs/source \
	dev-python/sphinx-rtd-theme \
	dev-python/nbsphinx \
	dev-python/sphinxcontrib-github-alt \
	dev-python/myst_parser \
	dev-python/ipython_genutils

EPYTEST_DESELECT=(
	# TODO: package jupyter_server_terminals
	tests/test_notebookapp.py::test_tree_handler
	tests/test_notebookapp.py::test_terminal_handler
)

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p pytest_tornasync.plugin
}

python_install_all() {
	distutils-r1_python_install_all
	# move /usr/etc stuff to /etc
	mv "${ED}/usr/etc" "${ED}/etc" || die
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

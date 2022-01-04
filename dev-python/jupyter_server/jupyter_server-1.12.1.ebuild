# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Core services, APIs, and REST endpoints to Jupyter web applications"
HOMEPAGE="https://jupyter.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/jinja[${PYTHON_USEDEP}]
	>=www-servers/tornado-6.1[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-17[${PYTHON_USEDEP}]
	dev-python/argon2-cffi[${PYTHON_USEDEP}]
	dev-python/ipython_genutils[${PYTHON_USEDEP}]
	>=dev-python/traitlets-4.2.1[${PYTHON_USEDEP}]
	>=dev-python/jupyter_core-4.6.0[${PYTHON_USEDEP}]
	>=dev-python/jupyter_client-6.1.1[${PYTHON_USEDEP}]
	dev-python/nbformat[${PYTHON_USEDEP}]
	dev-python/nbconvert[${PYTHON_USEDEP}]
	dev-python/send2trash[${PYTHON_USEDEP}]
	>=dev-python/terminado-0.8.3[${PYTHON_USEDEP}]
	dev-python/prometheus_client[${PYTHON_USEDEP}]
	dev-python/anyio[${PYTHON_USEDEP}]
	dev-python/websocket-client[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/ipykernel[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-tornasync[${PYTHON_USEDEP}]
		dev-python/pytest-console-scripts[${PYTHON_USEDEP}]
	)"

# TODO: Package 'myst_parser'
# distutils_enable_sphinx docs/source
# 	dev-python/pydata-sphinx-theme
distutils_enable_tests --install pytest

python_prepare_all() {
	# Defining 'pytest_plugins' in a non-top-level conftest is no longer supported:
	mv jupyter_server/conftest.py . || die

	# This fails if your terminal is zsh (and maybe other non-bash as well?)
	sed -i \
		-e 's:est_terminal_create_with_cwd:_&:' \
		-e 's:test_culling:_&:' \
		jupyter_server/tests/test_terminal.py || die

	distutils-r1_python_prepare_all
}

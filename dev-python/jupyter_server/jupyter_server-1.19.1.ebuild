# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=jupyter
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Core services, APIs, and REST endpoints to Jupyter web applications"
HOMEPAGE="https://jupyter.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/anyio-3.1.0[${PYTHON_USEDEP}]
	<dev-python/anyio-4[${PYTHON_USEDEP}]
	dev-python/argon2-cffi[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	>=dev-python/jupyter_client-6.1.1[${PYTHON_USEDEP}]
	>=dev-python/jupyter_core-4.7.0[${PYTHON_USEDEP}]
	>=dev-python/nbconvert-6.4.4[${PYTHON_USEDEP}]
	>=dev-python/nbformat-5.2.0[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/prometheus_client[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-17[${PYTHON_USEDEP}]
	dev-python/send2trash[${PYTHON_USEDEP}]
	>=dev-python/terminado-0.8.3[${PYTHON_USEDEP}]
	>=dev-python/tornado-6.1[${PYTHON_USEDEP}]
	>=dev-python/traitlets-5.1[${PYTHON_USEDEP}]
	dev-python/websocket-client[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/ipykernel[${PYTHON_USEDEP}]
		dev-python/pytest-console-scripts[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		dev-python/pytest-tornasync[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs/source \
	dev-python/pydata-sphinx-theme \
	dev-python/myst_parser \
	dev-python/ipython \
	dev-python/sphinxemoji \
	dev-python/sphinxcontrib-github-alt \
	dev-python/sphinxcontrib-openapi
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# This fails if your terminal is zsh (and maybe other non-bash as well?)
	tests/test_terminal.py::test_culling
	tests/test_terminal.py::test_terminal_create_with_cwd
	tests/test_terminal.py::test_terminal_create_with_relative_cwd
)

src_prepare() {
	# disable npm use
	sed -i -e '/\[tool\.jupyter-packaging\.builder\]/,+1d' pyproject.toml || die
	distutils-r1_src_prepare
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest \
		-p pytest_tornasync.plugin \
		-p jupyter_server.pytest_plugin \
		-p pytest_console_scripts \
		-p pytest_timeout
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="Core services, APIs, and REST endpoints to Jupyter web applications"
HOMEPAGE="
	https://jupyter.org/
	https://github.com/jupyter-server/jupyter_server/
	https://pypi.org/project/jupyter-server/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~s390"

RDEPEND="
	>=dev-python/anyio-3.1.0[${PYTHON_USEDEP}]
	dev-python/argon2-cffi[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	>=dev-python/jupyter-client-7.4.4[${PYTHON_USEDEP}]
	>=dev-python/jupyter-core-5.1.0[${PYTHON_USEDEP}]
	dev-python/jupyter-server-terminals[${PYTHON_USEDEP}]
	>=dev-python/jupyter-events-0.6.0[${PYTHON_USEDEP}]
	>=dev-python/nbconvert-6.4.4[${PYTHON_USEDEP}]
	>=dev-python/nbformat-5.3.0[${PYTHON_USEDEP}]
	dev-python/overrides[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/prometheus-client[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-24[${PYTHON_USEDEP}]
	dev-python/send2trash[${PYTHON_USEDEP}]
	>=dev-python/terminado-0.8.3[${PYTHON_USEDEP}]
	>=dev-python/tornado-6.2[${PYTHON_USEDEP}]
	>=dev-python/traitlets-5.6.0[${PYTHON_USEDEP}]
	dev-python/websocket-client[${PYTHON_USEDEP}]

"
BDEPEND="
	test? (
		dev-python/ipykernel[${PYTHON_USEDEP}]
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/pytest-console-scripts[${PYTHON_USEDEP}]
		dev-python/pytest-jupyter[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		dev-python/pytest-tornasync[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# This fails if your terminal is zsh (and maybe other non-bash as well?)
	tests/test_terminal.py
	# Fails because above is ignored
	tests/auth/test_authorizer.py
	# Fails with additional extensions installed
	tests/extension/test_app.py::test_stop_extension
)

PATCHES=(
	"${FILESDIR}/${PN}-2.0.1-skip-npm.patch"
)

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest \
		-p pytest_tornasync.plugin \
		-p jupyter_server.pytest_plugin \
		-p pytest_console_scripts \
		-p pytest_timeout
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi

DESCRIPTION="Jupyter protocol implementation and client libraries"
HOMEPAGE="
	https://jupyter.org/
	https://github.com/jupyter/jupyter_client/
	https://pypi.org/project/jupyter-client/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv sparc x86"

RDEPEND="
	>=dev-python/jupyter_core-5.1[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.8.2[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-23.0[${PYTHON_USEDEP}]
	>=dev-python/tornado-6.0[${PYTHON_USEDEP}]
	dev-python/traitlets[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/importlib_metadata-4.8.3[${PYTHON_USEDEP}]
	' 3.{8,9})
"
BDEPEND="
	test? (
		>=dev-python/ipykernel-6.14[${PYTHON_USEDEP}]
		>=dev-python/pytest-asyncio-0.18[${PYTHON_USEDEP}]
		>=dev-python/pytest_jupyter-0.4.1[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# TODO: times out
	tests/test_client.py::TestAsyncKernelClient::test_input_request
	# TODO
	tests/test_multikernelmanager.py::TestKernelManager::test_tcp_cinfo
)

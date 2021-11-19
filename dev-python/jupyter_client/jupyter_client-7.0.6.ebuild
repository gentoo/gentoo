# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="threads(+)"
inherit distutils-r1

DESCRIPTION="Jupyter protocol implementation and client libraries"
HOMEPAGE="https://jupyter.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ~ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/entrypoints[${PYTHON_USEDEP}]
	>=dev-python/jupyter_core-4.6.0[${PYTHON_USEDEP}]
	>=dev-python/nest_asyncio-1.5[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.1[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-14.4.0[${PYTHON_USEDEP}]
	>=www-servers/tornado-4.1[${PYTHON_USEDEP}]
	dev-python/traitlets[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/ipykernel[${PYTHON_USEDEP}]
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-7.0.6-test-timeout.patch
)

EPYTEST_DESELECT=(
	jupyter_client/tests/test_kernelmanager.py::TestKernelManagerShutDownGracefully::test_signal_kernel_subprocesses
	jupyter_client/tests/test_kernelmanager.py::TestKernelManagerShutDownGracefully::test_async_signal_kernel_subprocesses
)

distutils_enable_tests pytest

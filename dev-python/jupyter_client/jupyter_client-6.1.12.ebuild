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
KEYWORDS="amd64 arm arm64 ~ia64 ~ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/async_generator[${PYTHON_USEDEP}]
	dev-python/jupyter_core[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-14.4.0[${PYTHON_USEDEP}]
	dev-python/traitlets[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/ipykernel[${PYTHON_USEDEP}]
		dev-python/ipython[${PYTHON_USEDEP}]
		<dev-python/jedi-0.17.3[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

python_test() {
	local deselect=(
		jupyter_client/tests/test_kernelmanager.py::TestAsyncKernelManager::test_signal_kernel_subprocesses
		jupyter_client/tests/test_kernelmanager.py::TestAsyncKernelManager::test_start_new_async_kernel
	)
	epytest ${deselect[@]/#/--deselect }
}

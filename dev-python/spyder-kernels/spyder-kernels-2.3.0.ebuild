# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Kernels used by spyder on its ipython console"
HOMEPAGE="https://github.com/spyder-ide/spyder-kernels/
	https://pypi.org/project/spyder-kernels/"
SRC_URI="https://github.com/spyder-ide/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/cloudpickle[${PYTHON_USEDEP}]
	>=dev-python/ipykernel-6.9.2[${PYTHON_USEDEP}]
	>=dev-python/ipython-7.31.1[${PYTHON_USEDEP}]
	<dev-python/ipython-8[${PYTHON_USEDEP}]
	>=dev-python/jupyter_client-7.1.0[${PYTHON_USEDEP}]
	dev-python/matplotlib-inline[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-22.1.0[${PYTHON_USEDEP}]
	>=dev-python/wurlitzer-1.0.3[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/cython[${PYTHON_USEDEP}]
		dev-python/dask[${PYTHON_USEDEP}]
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/matplotlib[tk,${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/xarray[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

python_test() {
	local deselect=(
		# we no longer package distributed
		spyder_kernels/console/tests/test_console_kernel.py::test_dask_multiprocessing
		# RuntimeError: There is no current event loop in thread 'MainThread'.
		# https://bugs.gentoo.org/834893
		spyder_kernels/console/tests/test_console_kernel.py::test_cwd_in_sys_path
		spyder_kernels/console/tests/test_console_kernel.py::test_multiprocessing
		spyder_kernels/console/tests/test_console_kernel.py::test_multiprocessing_2
		spyder_kernels/console/tests/test_console_kernel.py::test_runfile
		spyder_kernels/console/tests/test_console_kernel.py::test_np_threshold
		spyder_kernels/console/tests/test_console_kernel.py::test_matplotlib_inline
	)

	epytest ${deselect[@]/#/--deselect }
}

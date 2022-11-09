# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Kernels used by spyder on its ipython console"
HOMEPAGE="
	https://github.com/spyder-ide/spyder-kernels/
	https://pypi.org/project/spyder-kernels/
"
SRC_URI="
	https://github.com/spyder-ide/spyder-kernels/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/cloudpickle[${PYTHON_USEDEP}]
	<dev-python/ipykernel-7[${PYTHON_USEDEP}]
	>=dev-python/ipykernel-6.16.1[${PYTHON_USEDEP}]
	>=dev-python/ipython-7.31.1[${PYTHON_USEDEP}]
	<dev-python/jupyter_client-8[${PYTHON_USEDEP}]
	>=dev-python/jupyter_client-7.3.4[${PYTHON_USEDEP}]
	<dev-python/jupyter_client-8[${PYTHON_USEDEP}]
	dev-python/matplotlib-inline[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-22.1.0[${PYTHON_USEDEP}]
	>=dev-python/wurlitzer-1.0.3[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/cython[${PYTHON_USEDEP}]
		dev-python/dask[${PYTHON_USEDEP}]
		dev-python/django[${PYTHON_USEDEP}]
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/xarray[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# we no longer package distributed
	spyder_kernels/console/tests/test_console_kernel.py::test_dask_multiprocessing
	# RuntimeError: There is no current event loop in thread 'MainThread'.
	# https://bugs.gentoo.org/834893
	spyder_kernels/console/tests/test_console_kernel.py::test_cwd_in_sys_path
	spyder_kernels/console/tests/test_console_kernel.py::test_multiprocessing
	spyder_kernels/console/tests/test_console_kernel.py::test_multiprocessing_2
	spyder_kernels/console/tests/test_console_kernel.py::test_runfile
	spyder_kernels/console/tests/test_console_kernel.py::test_np_threshold
	spyder_kernels/console/tests/test_console_kernel.py::test_turtle_launch
	spyder_kernels/console/tests/test_console_kernel.py::test_matplotlib_inline
)

python_prepare_all() {
	# No additional test failures with ipython-8: 843251
	sed -i -e "/ipython/s:,<8::" setup.py || die

	distutils-r1_python_prepare_all
}

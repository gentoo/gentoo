# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 multiprocessing

DESCRIPTION="Robust and reusable Executor for joblib"
HOMEPAGE="
	https://github.com/joblib/loky/
	https://pypi.org/project/loky/
"
SRC_URI="
	https://github.com/joblib/loky/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ppc64 ~riscv x86 ~arm64-macos ~x64-macos"

RDEPEND="
	dev-python/cloudpickle[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	EPYTEST_DESELECT=(
		# docker, seriously?
		tests/test_loky_module.py::test_cpu_count_cfs_limit
		tests/test_loky_module.py::test_cpu_count_cgroup_limit
		# hangs, and even pytest-timeout does not help
		tests/test_reusable_executor.py::TestExecutorDeadLock::test_deadlock_kill
		tests/test_reusable_executor.py::TestResizeExecutor::test_reusable_executor_resize
		# Python 3.12 raises an additional warning due to the use of fork()
		# in a multithreaded process, the additional warning breaks this test
		# since the expected warning is no longer the first.
		# This is harmless, skip test for now
		tests/test_worker_timeout.py::TestTimeoutExecutor::test_worker_timeout_shutdown_no_deadlock
		tests/test_reusable_executor.py::TestResizeExecutor::test_resize_after_timeout
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	# high memory test needs a lot of memory + is broken on 32-bit platforms
	epytest --skip-high-memory \
		-p xdist -n "$(makeopts_jobs)" --dist=worksteal
}

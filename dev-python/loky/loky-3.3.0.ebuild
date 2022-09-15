# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Robust and reusable Executor for joblib"
HOMEPAGE="https://github.com/joblib/loky"
SRC_URI="
	https://github.com/joblib/loky/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	dev-python/cloudpickle[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	EPYTEST_DESELECT=(
		# docker, seriously?
		tests/test_loky_module.py::test_cpu_count_cfs_limit
		# hangs, and even pytest-timeout does not help
		tests/test_reusable_executor.py::TestExecutorDeadLock::test_deadlock_kill
		tests/test_reusable_executor.py::TestResizeExecutor::test_reusable_executor_resize
	)

	# high memory test needs a lot of memory + is broken on 32-bit platforms
	epytest --skip-high-memory
}

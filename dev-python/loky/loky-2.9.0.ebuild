# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Robust and reusable Executor for joblib"
HOMEPAGE="https://github.com/joblib/loky"
SRC_URI="
	https://github.com/joblib/loky/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ppc64 x86"

RDEPEND="
	dev-python/cloudpickle[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/${P}-libc.patch
)

python_test() {
	local args=(
		# docker, seriously?
		--deselect 'tests/test_loky_module.py::test_cpu_count_cfs_limit'
		# hangs, and even pytest-timeout does not help
		--deselect 'tests/test_reusable_executor.py::TestExecutorDeadLock::test_deadlock_kill'
		# one test that uses a lot of memory, also broken on 32-bit
		# platforms
		--skip-high-memory
	)

	epytest "${args[@]}"
}

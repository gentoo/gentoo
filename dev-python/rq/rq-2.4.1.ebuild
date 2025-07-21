# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Simple, lightweight library for creating and processing background jobs"
HOMEPAGE="
	https://python-rq.org/
	https://github.com/rq/rq/
	https://pypi.org/project/rq/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	>=dev-python/click-5.0[${PYTHON_USEDEP}]
	>=dev-python/redis-4.5.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-db/redis
		dev-python/psutil[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# strip pin
	sed -i -e '/dependencies/s:,!=[0-9.]*::' pyproject.toml || die
}

src_test() {
	local redis_pid="${T}"/redis.pid
	local redis_port=6379
	local redis_test_config="daemonize yes
		pidfile ${redis_pid}
		port ${redis_port}
		bind 127.0.0.1
	"

	# Spawn Redis itself for testing purposes
	# NOTE: On sam@'s machine, spawning Redis can hang in the sandbox.
	# I'm not restricting tests yet because this doesn't happen for anyone else AFAICT.
	einfo "Spawning Redis"
	einfo "NOTE: Port ${redis_port} must be free"
	/usr/sbin/redis-server - <<< "${redis_test_config}" || die

	# Run the actual tests
	distutils-r1_src_test

	# Clean up afterwards
	kill "$(<"${redis_pid}")" || die
}

python_test() {
	local EPYTEST_DESELECT=(
		# requires <sentry-sdk-2
		tests/test_sentry.py::TestSentry::test_failure_capture
		# hang
		tests/test_commands.py::TestCommands::test_shutdown_command
		tests/test_worker_pool.py::TestWorkerPool::test_check_workers
		tests/test_dependencies.py::TestDependencies
		# already present in older versions
		tests/test_spawn_worker.py::TestWorker::test_work_and_quit
	)

	epytest
}

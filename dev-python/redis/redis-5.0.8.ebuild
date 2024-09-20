# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1

MY_P=redis-py-${PV}
DESCRIPTION="Python client for Redis key-value store"
HOMEPAGE="
	https://github.com/redis/redis-py/
	https://pypi.org/project/redis/
"
SRC_URI="
	https://github.com/redis/redis-py/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86"

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/async-timeout-4.0.2[${PYTHON_USEDEP}]
	' 3.10)
"
BDEPEND="
	test? (
		dev-db/redis
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# https://github.com/redis/redis-py/issues/3339
	sed -i 's:(forbid_global_loop=True)::' tests/test_asyncio/*.py || die
}

python_test() {
	local EPYTEST_DESELECT=(
		# Flaky test
		tests/test_pubsub.py::TestPubSubDeadlock::test_pubsub_deadlock
		# require extra redis modules that apparently aren't packaged
		# on Gentoo
		tests/{,test_asyncio/}test_bloom.py
		tests/{,test_asyncio/}test_graph.py
		tests/{,test_asyncio/}test_json.py
		tests/{,test_asyncio/}test_timeseries.py
		# apparently available only in "Redis Stack 7.2 RC3 or later"
		tests/test_commands.py::TestRedisCommands::test_tfunction_load_delete
		tests/test_commands.py::TestRedisCommands::test_tfunction_list
		tests/test_commands.py::TestRedisCommands::test_tfcall
		# TODO
		tests/test_commands.py::TestRedisCommands::test_module
		tests/test_commands.py::TestRedisCommands::test_module_loadex
		tests/test_commands.py::TestRedisCommands::test_zrank_withscore
		tests/test_commands.py::TestRedisCommands::test_zrevrank_withscore
		tests/test_commands.py::TestRedisCommands::test_xinfo_consumers
		tests/test_asyncio/test_commands.py::TestRedisCommands::test_zrank_withscore
		tests/test_asyncio/test_commands.py::TestRedisCommands::test_zrevrank_withscore
		tests/test_asyncio/test_commands.py::TestRedisCommands::test_xinfo_consumers
		tests/test_asyncio/test_pubsub.py::TestPubSubAutoReconnect::test_reconnect_socket_error[pool-hiredis-listen]
	)

	# TODO: try to run more servers?
	epytest -m "not redismod and not onlycluster and not replica and not ssl"
}

src_test() {
	local redis_pid="${T}"/redis.pid
	local redis_port=6379

	if has_version ">=dev-db/redis-7"; then
		local extra_conf="
			enable-debug-command yes
			enable-module-command yes
		"
	fi

	# Spawn Redis itself for testing purposes
	einfo "Spawning Redis"
	einfo "NOTE: Port ${redis_port} must be free"
	"${EPREFIX}"/usr/sbin/redis-server - <<- EOF || die "Unable to start redis server"
		daemonize yes
		pidfile ${redis_pid}
		port ${redis_port}
		bind 127.0.0.1 ::1
		${extra_conf}
	EOF

	# Run the tests
	distutils-r1_src_test

	# Clean up afterwards
	kill "$(<"${redis_pid}")" || die
}

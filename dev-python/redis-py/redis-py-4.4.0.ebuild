# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

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
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv sparc x86"

RDEPEND="
	>=dev-python/async-timeout-4.0.2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-db/redis
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# Flaky test
		tests/test_pubsub.py::TestPubSubDeadlock::test_pubsub_deadlock
		# TODO
		tests/test_commands.py::TestRedisCommands::test_acl_list
		# redis-7 different return
		tests/test_commands.py::TestRedisCommands::test_xautoclaim
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

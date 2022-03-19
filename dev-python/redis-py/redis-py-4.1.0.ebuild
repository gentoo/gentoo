# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

MY_PN="redis"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python client for Redis key-value store"
HOMEPAGE="https://github.com/redis/redis-py"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 sparc x86"

RDEPEND="
	dev-python/deprecated[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-db/redis
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	distutils_install_for_testing

	local EPYTEST_DESELECT=(
		# Flaky test
		tests/test_pubsub.py::TestPubSubDeadlock::test_pubsub_deadlock

		# Needs a second Redis running
		tests/test_commands.py::TestRedisCommands::test_sync
		tests/test_commands.py::TestRedisCommands::test_psync
	)

	local EPYTEST_IGNORE=(
		# SSL tests need Docker/stunnel:
		# https://github.com/redis/redis-py/commit/18c6809b761bc6755349e1d7e08e74e857ec2c65
		tests/test_ssl.py

		# Needs multiple Redises running
		tests/test_cluster.py
	)

	epytest -k "not redismod and not ssl"
}

src_test() {
	local redis_pid="${T}"/redis.pid
	local redis_port=6379
	local redis_test_config="
		daemonize yes
		pidfile ${redis_pid}
		port ${redis_port}
		bind 127.0.0.1
	"

	# Spawn Redis itself for testing purposes
	# NOTE: On sam@'s machine, spawning Redis can hang in the sandbox.
	# I'm not restricting tests yet because this doesn't happen for anyone else AFAICT.
	einfo "Spawning Redis"
	einfo "NOTE: Port ${redis_port} must be free"
	"${EPREFIX}"/usr/sbin/redis-server - <<< "${redis_test_config}" || die

	# Run the tests
	distutils-r1_src_test

	# Clean up afterwards
	kill "$(<"${redis_pid}")" || die
}

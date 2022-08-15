# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Python client for Redis key-value store"
HOMEPAGE="
	https://github.com/redis/redis-py/
	https://pypi.org/project/redis/
"
SRC_URI="
	https://github.com/redis/redis-py/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv sparc x86"

RDEPEND="
	>=dev-python/async-timeout-4.0.2[${PYTHON_USEDEP}]
	>=dev-python/deprecated-1.2.3[${PYTHON_USEDEP}]
	>=dev-python/packaging-20.4[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		<dev-db/redis-7
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# Flaky test
		tests/test_pubsub.py::TestPubSubDeadlock::test_pubsub_deadlock
	)

	# TODO: try to run more servers?
	epytest -m "not redismod and not onlycluster and not replica and not ssl"
}

src_test() {
	local redis_pid="${T}"/redis.pid
	local redis_port=6379

	# Spawn Redis itself for testing purposes
	# NOTE: On sam@'s machine, spawning Redis can hang in the sandbox.
	# I'm not restricting tests yet because this doesn't happen for anyone else AFAICT.
	einfo "Spawning Redis"
	einfo "NOTE: Port ${redis_port} must be free"
	# "${EPREFIX}"/usr/sbin/redis-server - <<< "${redis_test_config}" || die
	"${EPREFIX}"/usr/sbin/redis-server - <<- EOF || die "Unable to start redis server"
		daemonize yes
		pidfile ${redis_pid}
		port ${redis_port}
		bind 127.0.0.1
	EOF

	# Run the tests
	distutils-r1_src_test

	# Clean up afterwards
	kill "$(<"${redis_pid}")" || die
}

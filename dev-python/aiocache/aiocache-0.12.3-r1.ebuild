# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Asyncio cache manager"
HOMEPAGE="
	https://github.com/aio-libs/aiocache/
	https://pypi.org/project/aiocache/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	test? (
		dev-db/redis
		dev-python/marshmallow[${PYTHON_USEDEP}]
		>=dev-python/msgpack-0.5.5[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		>=dev-python/redis-4.2.0[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/${P}-py313.patch
)

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# broken by newer dev-python/redis (?), removed upstream
		tests/ut/backends/test_redis.py::TestRedisBackend::test_close
	)
	local EPYTEST_IGNORE=(
		# benchmarks
		tests/performance
		# requires aiomcache
		tests/ut/backends/test_memcached.py
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -o addopts= -m "not memcached" -p asyncio -p pytest_mock
}

src_test() {
	local redis_pid="${T}"/redis.pid
	local redis_port=6379

	# Spawn Redis for testing purposes
	einfo "Spawning Redis"
	einfo "NOTE: Port ${redis_port} must be free"
	"${EPREFIX}"/usr/sbin/redis-server - <<- EOF || die "Unable to start redis server"
		daemonize yes
		pidfile ${redis_pid}
		port ${redis_port}
		bind 127.0.0.1 ::1
	EOF

	# Run the tests
	distutils-r1_src_test

	# Clean up afterwards
	kill "$(<"${redis_pid}")" || die
}

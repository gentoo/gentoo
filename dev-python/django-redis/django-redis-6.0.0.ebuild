# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Full featured redis cache backend for Django"
HOMEPAGE="
	https://github.com/jazzband/django-redis/
	https://pypi.org/project/django-redis/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/django-4.2[${PYTHON_USEDEP}]
	>=dev-python/redis-4.0.2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-db/redis
		dev-python/lz4[${PYTHON_USEDEP}]
		dev-python/msgpack[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-{mock,xdist} )
EPYTEST_XDIST=1
distutils_enable_tests pytest

src_prepare() {
	sed -e '/--cov/d' \
		-e '/--no-cov/d' \
		-i setup.cfg || die
	distutils-r1_src_prepare
}

python_test() {
	# no clue why we need to set it explicitly
	local -x DJANGO_SETTINGS_MODULE=settings.sqlite
	# sqlite_zstd requires pyzstd
	# the test suite only works with -n4
	# https://github.com/jazzband/django-redis/issues/777
	epytest -n 4 -k "not sqlite_zstd"
}

src_test() {
	local redis_pid="${T}"/redis.pid
	local redis_port=6379
	local redis_sock="${T}"/redis.sock
	local redis_test_config="
		daemonize yes
		pidfile ${redis_pid}
		port ${redis_port}
		unixsocket ${redis_sock}
		bind 127.0.0.1
		logfile ${T}/redis.log
		enable-debug-command yes
	"
	local sentinel_pid="${T}"/sentinel.pid
	local sentinel_port=26379

	# Spawn Redis itself for testing purposes
	einfo "Spawning Redis"
	einfo "NOTE: Port ${redis_port} must be free"
	"${EPREFIX}"/usr/sbin/redis-server - <<< "${redis_test_config}" || die

	# Also Redis sentinel
	cat > "${T}"/sentinel.conf <<-EOF || die
		# from docker/sentinel.conf
		sentinel monitor default_service 127.0.0.1 ${redis_port} 1
		sentinel down-after-milliseconds default_service 3200
		sentinel failover-timeout default_service 10000

		# for some reason, tests expect 127.0.0.1 too
		sentinel monitor 127.0.0.1 127.0.0.1 ${redis_port} 1
		sentinel down-after-milliseconds 127.0.0.1 3200
		sentinel failover-timeout 127.0.0.1 10000

		daemonize yes
		pidfile ${sentinel_pid}
		port ${sentinel_port}
		logfile ${T}/sentinel.log
	EOF
	"${EPREFIX}"/usr/sbin/redis-sentinel "${T}"/sentinel.conf || die

	# Update the socket path, we don't want hardcoded /tmp
	sed -e "s^/tmp/redis.sock^${redis_sock}^g" \
		-i tests/settings/sqlite_usock.py || die

	# Run the tests
	distutils-r1_src_test

	# Clean up afterwards
	kill "$(<"${sentinel_pid}")" "$(<"${redis_pid}")" || die
}

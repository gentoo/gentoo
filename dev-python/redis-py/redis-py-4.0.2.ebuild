# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} pypy3 )
inherit distutils-r1

MY_PN="redis"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python client for Redis key-value store"
HOMEPAGE="https://github.com/redis/redis-py"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/deprecated[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-db/redis
	)
"

distutils_enable_tests pytest

python_test() {
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
	elog "Spawning Redis"
	elog "NOTE: Port ${redis_port} must be free"
	"${EPREFIX}"/usr/sbin/redis-server - <<< "${redis_test_config}" || die

	# Run the tests
	epytest -k "not redismod"

	# Clean up afterwards
	local pid=$(<"${redis_pid}")
	kill "${pid}" || die
	local retries=10
	while [[ -f ${redis_pid} ]]; do
		sleep 1
		if [[ $(( retries-- )) -eq 0 ]]; then
			die "redis did not stop"
		fi
	done
}

# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{8..10} )
inherit distutils-r1 optfeature

DESCRIPTION="Fake implementation of redis API for testing purposes"
HOMEPAGE="
	https://github.com/jamesls/fakeredis/
	https://pypi.org/project/fakeredis/"
SRC_URI="
	https://github.com/jamesls/fakeredis/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	dev-python/redis-py[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/sortedcontainers[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-db/redis
		dev-python/aioredis[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	test/test_aioredis2.py::test_blocking_unblock
	test/test_aioredis2.py::test_pubsub
	"test/test_aioredis2.py::test_repr[fake]"
	test/test_hypothesis.py::TestJoint::test
	test/test_hypothesis.py::TestFuzz::test
)

python_test() {
	local args=(
		# tests requiring lupa (lua support)
		-k 'not test_eval and not test_lua and not test_script'
	)
	epytest "${args[@]}"
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

	einfo "Spawning Redis"
	einfo "NOTE: Port ${redis_port} must be free"
	"${EPREFIX}"/usr/sbin/redis-server - <<< "${redis_test_config}" || die

	# Run the tests
	distutils-r1_src_test

	# Clean up afterwards
	kill "$(<"${redis_pid}")" || die
}

pkg_postinst() {
	optfeature "Mock aioredis" dev-python/aioredis
}

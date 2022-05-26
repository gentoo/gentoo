# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..10} )

inherit distutils-r1 optfeature

MY_P=fakeredis-py-${PV}
DESCRIPTION="Fake implementation of redis API for testing purposes"
HOMEPAGE="
	https://github.com/dsoftwareinc/fakeredis-py/
	https://pypi.org/project/fakeredis/
"
SRC_URI="
	https://github.com/dsoftwareinc/fakeredis-py/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	dev-python/redis-py[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/sortedcontainers[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-db/redis
		dev-python/aioredis[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	# unpin redis
	sed -i -e '/redis/s:<=.*::' setup.cfg || die
	distutils-r1_src_prepare
}

python_test() {
	local EPYTEST_DESELECT=(
		# also lupa
		test/test_aioredis2.py::test_failed_script_error
		# TODO
		"test/test_fakeredis.py::test_set_get_nx[StrictRedis]"
		"test/test_fakeredis.py::test_lpop_count[StrictRedis]"
		"test/test_fakeredis.py::test_rpop_count[StrictRedis]"
		"test/test_fakeredis.py::test_zadd_minus_zero[StrictRedis]"
	)
	local EPYTEST_IGNORE=(
		# these tests fail a lot...
		test/test_hypothesis.py
	)
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

# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Fake implementation of redis API for testing purposes"
HOMEPAGE="
	https://github.com/cunla/fakeredis-py/
	https://pypi.org/project/fakeredis/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/redis-4.3[${PYTHON_USEDEP}]
	<dev-python/sortedcontainers-3[${PYTHON_USEDEP}]
	>=dev-python/sortedcontainers-2[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	' 3.10)
"
BDEPEND="
	test? (
		dev-db/redis
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# https://github.com/cunla/fakeredis-py/issues/320
	sed -i -e '/LICENSE/d' pyproject.toml || die
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
		"test/test_mixins/test_pubsub_commands.py::test_pubsub_channels[StrictRedis]"
		test/test_mixins/test_set_commands.py::test_smismember_wrong_type
		# new redis-server?
		"test/test_mixins/test_pubsub_commands.py::test_pubsub_shardnumsub[StrictRedis]"
		# json ext
		test/test_json/test_json.py
		test/test_json/test_json_arr_commands.py
		# tdigest ext?
		'test/test_mixins/test_server_commands.py::test_command[FakeStrictRedis]'
	)
	local EPYTEST_IGNORE=(
		# these tests fail a lot...
		test/test_hypothesis.py
	)
	local args=(
		# tests requiring lupa (lua support)
		-k 'not test_eval and not test_lua and not test_script'
	)
	# Note: this package is not xdist-friendly
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p asyncio -p pytest_mock "${args[@]}"
}

src_test() {
	local redis_pid="${T}"/redis.pid
	local redis_port=6390

	einfo "Spawning Redis"
	einfo "NOTE: Port ${redis_port} must be free"
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

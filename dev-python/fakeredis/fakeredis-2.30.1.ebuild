# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Fake implementation of redis API for testing purposes"
HOMEPAGE="
	https://github.com/cunla/fakeredis-py/
	https://pypi.org/project/fakeredis/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv ~sparc x86"

RDEPEND="
	>=dev-python/redis-4.3[${PYTHON_USEDEP}]
	<dev-python/sortedcontainers-3[${PYTHON_USEDEP}]
	>=dev-python/sortedcontainers-2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-db/redis
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

# pytest-xdist: tests are not parallel-safe
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# TODO
		"test/test_mixins/test_pubsub_commands.py::test_pubsub_channels[StrictRedis2]"
		"test/test_mixins/test_pubsub_commands.py::test_pubsub_channels[StrictRedis3]"
		"test/test_mixins/test_pubsub_commands.py::test_published_message_to_shard_channel[StrictRedis3]"
		test/test_mixins/test_set_commands.py::test_smismember_wrong_type
		"test/test_mixins/test_pubsub_commands.py::test_pubsub_shardnumsub[StrictRedis2]"
		"test/test_mixins/test_pubsub_commands.py::test_pubsub_shardnumsub[StrictRedis3]"
		# json ext
		test/test_json/test_json.py
		test/test_json/test_json_arr_commands.py
	)
	local EPYTEST_IGNORE=(
		# these tests fail a lot...
		test/test_hypothesis
		test/test_hypothesis_joint.py
	)

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

# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/cunla/fakeredis-py
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Fake implementation of redis API for testing purposes"
HOMEPAGE="
	https://github.com/cunla/fakeredis-py/
	https://pypi.org/project/fakeredis/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	>=dev-python/redis-4.3[${PYTHON_USEDEP}]
	>=dev-python/sortedcontainers-2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-db/redis
		dev-db/valkey
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/valkey[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-{asyncio,mock} )
EPYTEST_XDIST=1
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# do not install duplicate license
	sed -i -e '\@fakeredis/LICENSE@d' pyproject.toml || die
}

wait_for_status() {
	local expected=${1}

	local i
	for i in {1..50}; do
		"${server}-cli" -p "${redis_port}" ping
		[[ ${?} -eq ${expected} ]] && return
		sleep 0.2
	done

	die "Timeout while waiting for ${1}-server to start/stop"
}

src_test() {
	local server
	server=fake
	einfo "Running ${server} server tests"
	distutils-r1_src_test

	for server in redis valkey; do
		local redis_pid="${T}/${server}.pid"
		local redis_port=6390
		local redis_log="${T}/${server}.log"
		local redis_db="${T}/${server}.db"

		einfo "Running ${server} server tests"
		"${EPREFIX}/usr/sbin/${server}-server" - <<- EOF || die "Unable to start ${server} server"
			daemonize yes
			pidfile ${redis_pid}
			port ${redis_port}
			logfile ${redis_log}
			dir ${redis_db%/*}
			dbfilename ${redis_db##*/}
			bind 127.0.0.1
		EOF

		# wait for the server to start
		wait_for_status 0

		distutils-r1_src_test

		"${server}-cli" -p "${redis_port}" shutdown || die "Unable to stop ${server} server"

		# wait for the server to stop
		wait_for_status 1
	done
}

python_test() {
	local EPYTEST_DESELECT=(
		# json ext
		test/test_stack/test_json.py
		test/test_stack/test_json_arr_commands.py
		# TODO
		"test/test_mixins/test_pubsub_commands.py::test_published_message_to_shard_channel[Strict3]"
		"test/test_mixins/test_pubsub_commands.py::test_pubsub_shardnumsub[Strict2]"
		"test/test_mixins/test_pubsub_commands.py::test_pubsub_shardnumsub[Strict3]"
	)

	local EPYTEST_IGNORE=(
		# these tests fail a lot...
		test/test_hypothesis
		test/test_hypothesis_joint.py
	)

	case ${server} in
		fake)
			EPYTEST_DESELECT=(
				# TODO
				test/test_tcp_server/test_connectivity.py::test_bulk_string_length
			)

			# every test starts its own server
			EPYTEST_XDIST= epytest -m "tcp_server"
			return
			;;
		redis)
			EPYTEST_DESELECT+=(
				"test/test_mixins/test_set_commands.py::test_smismember_wrong_type[Strict2]"
				"test/test_mixins/test_set_commands.py::test_smismember_wrong_type[Strict3]"

				"test/test_async/test_redis_only.py::test_async_lock[fake_resp2]"
				"test/test_async/test_redis_only.py::test_async_lock[fake_resp3]"
				"test/test_mixins/test_set_commands.py::test_smismember_wrong_type[FakeStrict2]"
				"test/test_mixins/test_set_commands.py::test_smismember_wrong_type[FakeStrict3]"
			)

			# run fake tests only once
			epytest -m "not real and not tcp_server"
			;;
	esac

	# we can run "fake" tests in parallel, but "real" seem to share
	# the same connection
	EPYTEST_XDIST= epytest -m "real"
}

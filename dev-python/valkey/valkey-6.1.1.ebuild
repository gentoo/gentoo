# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/valkey-io/valkey-py
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Python client for Valkey forked from redis-py"
HOMEPAGE="
	https://github.com/valkey-io/valkey-py/
	https://pypi.org/project/valkey/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~sparc ~x86"

BDEPEND="
	test? (
		dev-db/valkey
		dev-python/cachetools[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-{asyncio,timeout} )
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# requires cluster
		tests/{,test_asyncio/}test_cache.py::TestSentinelLocalCache::test_get_from_cache
		tests/{,test_asyncio/}'test_cache.py::TestSentinelLocalCache::test_cache_decode_response[sentinel_setup0]'
		# unexpected commands (different valkey version?)
		tests/test_commands.py::TestValkeyCommands::test_acl_getuser_setuser
		# looks like upstream didn't bother updating the server name here
		tests/test_commands.py::TestValkeyCommands::test_lolwut
	)
	local EPYTEST_IGNORE=(
		# missing modules
		tests/{,test_asyncio/}test_bloom.py
		tests/{,test_asyncio/}test_json.py
		tests/{,test_asyncio/}test_search.py
		tests/{,test_asyncio/}test_timeseries.py
		# missing SSL certificates
		tests/test_asyncio/test_cluster.py
		tests/test_ssl.py
	)

	# TODO: try to run more servers?
	epytest --asyncio-mode=auto \
		-m "not valkeymod and not onlycluster and not replica and not ssl"
}

src_test() {
	local valkey_pid="${T}"/valkey.pid
	local valkey_port=6379

	# Spawn valkey itself for testing purposes
	einfo "Spawning valkey"
	einfo "NOTE: Port ${valkey_port} must be free"
	"${EPREFIX}"/usr/sbin/valkey-server - <<- EOF || die "Unable to start valkey server"
		daemonize yes
		pidfile ${valkey_pid}
		port ${valkey_port}
		bind 127.0.0.1 ::1
		enable-debug-command yes
		enable-module-command yes
	EOF

	# Run the tests
	distutils-r1_src_test

	# Clean up afterwards
	kill "$(<"${valkey_pid}")" || die
}

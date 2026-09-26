# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit-core
PYPI_VERIFY_REPO=https://github.com/pallets-eco/cachelib
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Collection of cache libraries in the same API interface. Extracted from werkzeug"
HOMEPAGE="
	https://pypi.org/project/cachelib/
	https://github.com/pallets-eco/cachelib/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 arm64 ~x86"

BDEPEND="
	test? (
		dev-db/redis
		dev-db/valkey
		>=dev-python/python-memcached-1.62[${PYTHON_USEDEP}]
		dev-python/redis[${PYTHON_USEDEP}]
		dev-python/valkey[${PYTHON_USEDEP}]
		net-misc/memcached
		!sparc? (
			dev-python/pylibmc[${PYTHON_USEDEP}]
		)
	)
"

EPYTEST_PLUGINS=( pytest-xprocess )
EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local EPYTEST_IGNORE=(
		# requires some test server running
		# (these tests require dev-python/boto3)
		tests/test_dynamodb_cache.py
		# requires mongo test server
		tests/test_mongodb_cache.py
	)
	local EPYTEST_DESELECT=()

	local serial_tests=(
		tests/test_memcached_cache.py::TestMemcachedCache
		tests/test_redis_cache.py::TestRedisCache
		tests/test_valkey_cache.py::TestValkeyCache
	)

	EPYTEST_XDIST= epytest "${serial_tests[@]}"

	EPYTEST_DESELECT+=( "${serial_tests[@]}" )
	epytest
}

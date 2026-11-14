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
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="elibc_musl"

BDEPEND="
	test? (
		dev-db/redis
		dev-db/valkey
		>=dev-python/python-memcached-1.62[${PYTHON_USEDEP}]
		dev-python/pylibmc[${PYTHON_USEDEP}]
		dev-python/redis[${PYTHON_USEDEP}]
		dev-python/valkey[${PYTHON_USEDEP}]
		>=net-misc/memcached-1.6.45-r1[sasl]
		!elibc_musl? (
			!x86? (
				dev-db/mongodb
				dev-python/pymongo[${PYTHON_USEDEP}]
			)
		)
	)
"

EPYTEST_PLUGINS=( pytest-xprocess )
EPYTEST_XDIST=1
distutils_enable_tests pytest

src_test() {
	# see docker-compose.yaml
	# memcached
	mkdir -p "${T}/sasl2" || die
	echo "mech_list: plain" > "${T}/sasl2/memcached.conf" || die
	echo "cachelib@${HOSTNAME}:cachelib" > "${T}/memcached-sasl-pwdb" || die
	local -x SASL_CONF_PATH="${T}/sasl2"
	local -x MEMCACHED_SASL_PWDB="${T}/memcached-sasl-pwdb"
	memcached -d -S -p 11213 -l localhost \
		-P "${T}/m.pid" || die

	# mongodb
	local have_mongodb=
	if has_version dev-db/mongodb; then
		have_mongodb=1
		local dbpath=${TMPDIR}/mongo.db
		local logpath=${TMPDIR}/mongod.log
		local mongod_options=(
			--dbpath "${dbpath}"
			--bind_ip "127.0.0.1"
			--port 27017
			--unixSocketPrefix "${TMPDIR}"
			--logpath "${logpath}"
			--fork
		)

		mkdir -p "${dbpath}" || die
		LC_ALL=C mongod "${mongod_options[@]}" && sleep 2
		if [[ ${?} -ne 0 || ! -S "${TMPDIR}"/mongodb-27017.sock ]]; then
			eerror "Unable to start mongod for tests. See the server log:"
			eerror "	${logpath}"
			die "Unable to start mongod for tests."
		fi
	fi

	distutils-r1_src_test

	if [[ ${have_mongodb} ]]; then
		mongod --dbpath "${dbpath}" --shutdown || die
	fi
	kill "$(<"${T}/m.pid")" || die
}

python_test() {
	local EPYTEST_IGNORE=(
		# requires dynamodb test server
		# (these tests require dev-python/boto3)
		tests/test_dynamodb_cache.py
		# requires GCS server
		tests/test_googlecloudstorage_cache.py
	)

	local EPYTEST_DESELECT=()

	local serial_tests=(
		tests/test_memcached_cache.py::TestMemcachedCache
		tests/test_redis_cache.py::TestRedisCache
		tests/test_redis_cluster_cache.py
		tests/test_redis_sentinel_cache.py
		tests/test_sasl_memcached_cache.py
		tests/test_valkey_cache.py::TestValkeyCache
	)

	if [[ ${have_mongodb} ]]; then
		serial_tests+=(
			tests/test_mongodb_cache.py
		)
	else
		EPYTEST_IGNORE+=(
			tests/test_mongodb_cache.py
		)
	fi

	EPYTEST_XDIST= epytest "${serial_tests[@]}"

	EPYTEST_DESELECT+=( "${serial_tests[@]}" )
	epytest
}

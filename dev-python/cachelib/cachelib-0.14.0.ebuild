# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYPI_VERIFY_REPO=https://github.com/pallets-eco/cachelib
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Collection of cache libraries in the same API interface. Extracted from werkzeug"
HOMEPAGE="
	https://pypi.org/project/cachelib/
	https://github.com/pallets-eco/cachelib/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

BDEPEND="
	test? (
		dev-db/redis
		dev-python/redis[${PYTHON_USEDEP}]
		net-misc/memcached
		www-servers/uwsgi[python,${PYTHON_USEDEP}]
		!sparc? (
			dev-python/pylibmc[${PYTHON_USEDEP}]
		)
	)
"

EPYTEST_PLUGINS=( pytest-xprocess )
distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# bug #818523
	tests/test_redis_cache.py
	# requires some test server running
	# (these tests require dev-python/boto3)
	tests/test_dynamodb_cache.py
	# requires mongo test server
	tests/test_mongodb_cache.py
)

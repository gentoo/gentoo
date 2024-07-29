# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Collection of cache libraries in the same API interface. Extracted from werkzeug"
HOMEPAGE="
	https://pypi.org/project/cachelib/
	https://github.com/pallets-eco/cachelib/
"
SRC_URI="
	https://github.com/pallets-eco/cachelib/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86"

BDEPEND="
	test? (
		dev-db/redis
		dev-python/pytest-xprocess[${PYTHON_USEDEP}]
		dev-python/redis[${PYTHON_USEDEP}]
		net-misc/memcached
		www-servers/uwsgi[python,${PYTHON_USEDEP}]
		!sparc? (
			dev-python/pylibmc[${PYTHON_USEDEP}]
		)
	)
"

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

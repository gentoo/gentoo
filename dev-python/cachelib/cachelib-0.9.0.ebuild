# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

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
KEYWORDS="amd64 ~arm ~arm64 x86"

BDEPEND="
	test? (
		dev-db/redis
		dev-python/pylibmc[${PYTHON_USEDEP}]
		dev-python/pytest-xprocess[${PYTHON_USEDEP}]
		dev-python/redis-py[${PYTHON_USEDEP}]
		net-misc/memcached
		www-servers/uwsgi[python,${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# bug #818523
	tests/test_redis_cache.py
)

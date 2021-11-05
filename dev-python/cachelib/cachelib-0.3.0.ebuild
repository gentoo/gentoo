# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1

DESCRIPTION="Collection of cache libraries in the same API interface. Extracted from werkzeug"
HOMEPAGE="https://pypi.org/project/cachelib/ https://github.com/pallets/cachelib"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"

BDEPEND="
	test? (
		dev-python/pylibmc[${PYTHON_USEDEP}]
		dev-python/pytest-xprocess[${PYTHON_USEDEP}]
		dev-python/redis-py[${PYTHON_USEDEP}]
		net-misc/memcached
		www-servers/uwsgi[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# bug #818523
	tests/test_redis_cache.py
)

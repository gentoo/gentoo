# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYPI_PN=Flask-Caching
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Adds caching support to Flask applications"
HOMEPAGE="
	https://github.com/pallets-eco/flask-caching/
	https://pypi.org/project/Flask-Caching/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~x86"

RDEPEND="
	>=dev-python/cachelib-0.9.0[${PYTHON_USEDEP}]
	>=dev-python/flask-2.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/asgiref[${PYTHON_USEDEP}]
		dev-python/pylibmc[sasl(-),${PYTHON_USEDEP}]
		dev-python/redis[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-{asyncio,xprocess} )
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# broken with new redis
	tests/test_backend_cache.py::TestRedisCache::test_generic_inc_dec
)

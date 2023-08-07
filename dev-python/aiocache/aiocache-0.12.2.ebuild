# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Asyncio cache manager"
HOMEPAGE="
	https://github.com/aio-libs/aiocache/
	https://pypi.org/project/aiocache/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	test? (
		>=dev-python/msgpack-0.5.5[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		>=dev-python/redis-4.2.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_IGNORE=(
		# require running servers
		# TODO: start redis and enable them
		tests/acceptance
		# benchmarks
		tests/performance
		# requires aiomcache
		tests/ut/backends/test_memcached.py
	)

	epytest -o addopts= -m "not memcached"
}

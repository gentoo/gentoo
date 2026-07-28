# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit-core
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="A library for comparing dictionaries, iterables, strings and other objects"
HOMEPAGE="
	https://github.com/qlustered/deepdiff/
	https://pypi.org/project/deepdiff/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/cachebox-5.2[${PYTHON_USEDEP}]
	>=dev-python/click-8.1.3[${PYTHON_USEDEP}]
	>=dev-python/orderly-set-5.5.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6.0[${PYTHON_USEDEP}]
"

DEPEND="
	test? (
		>=dev-python/jsonpickle-4.0.0[${PYTHON_USEDEP}]
		>=dev-python/numpy-2.2.0[${PYTHON_USEDEP}]
		>=dev-python/orjson-3.10.0[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/pydantic[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		dev-python/tomli-w[${PYTHON_USEDEP}]
		dev-python/uuid6[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# benchmarks
	tests/test_lfucache.py::TestDistanceCache::test_lru_cache
	tests/test_lfucache.py::TestLFUcache::test_lfu
	# requires polars
	tests/test_hash.py::TestDeepHashPrep::test_polars
)

src_prepare() {
	distutils-r1_src_prepare

	# unpin dependencies
	sed -i -e 's:,<[0-9.]*::' pyproject.toml || die
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P="elasticsearch-py-${PV}"
DESCRIPTION="Official Elasticsearch client library for Python"
HOMEPAGE="
	https://ela.st/es-python
	https://github.com/elastic/elasticsearch-py/
	https://pypi.org/project/elasticsearch/
"
SRC_URI="
	https://github.com/elastic/elasticsearch-py/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1)"
KEYWORDS="amd64 ~arm64 ~x86"

RDEPEND="
	<dev-python/aiohttp-4[${PYTHON_USEDEP}]
	>=dev-python/aiohttp-3[${PYTHON_USEDEP}]
	<dev-python/elastic-transport-9[${PYTHON_USEDEP}]
	>=dev-python/elastic-transport-8[${PYTHON_USEDEP}]
	<dev-python/requests-3[${PYTHON_USEDEP}]
	>=dev-python/requests-2.4[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		dev-python/mapbox-vector-tile[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-5.4[${PYTHON_USEDEP}]
		dev-python/unasync[${PYTHON_USEDEP}]
	)
"

EPYTEST_IGNORE=(
	# REST api tests are a black hole for effort. It downloads the tests
	# so its an ever moving target. It also requires effort to blacklist
	# tests for apis which are license restricted.
	"test_elasticsearch/test_server/test_rest_api_spec.py"
	# Counting deprecation warnings from python is bound to fail even
	# if all are fixed in this package. Not worth it.
	"test_elasticsearch/test_client/test_deprecated_options.py"
	# Running daemon for tests is finicky and upstream CI fails at it
	# as well.
	"test_elasticsearch/test_server/"
	"test_elasticsearch/test_async/test_server/"
)

distutils_enable_sphinx docs/sphinx \
	dev-python/sphinx-autodoc-typehints \
	dev-python/sphinx-rtd-theme
distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -o addopts= -p asyncio
}

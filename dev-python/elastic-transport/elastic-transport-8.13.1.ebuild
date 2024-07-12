# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1

MY_P=elastic-transport-python-${PV}
DESCRIPTION="Transport classes and utilities shared among Python Elastic client libraries"
HOMEPAGE="
	https://github.com/elastic/elastic-transport-python/
	https://pypi.org/project/elastic-transport/
"
SRC_URI="
	https://github.com/elastic/elastic-transport-python/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 x86"
PROPERTIES="test_network"
RESTRICT="test"

RDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.26.2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/aiohttp[${PYTHON_USEDEP}]
		dev-python/httpx[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/opentelemetry-api[${PYTHON_USEDEP}]
		dev-python/opentelemetry-sdk[${PYTHON_USEDEP}]
		dev-python/orjson[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-httpserver[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/respx[${PYTHON_USEDEP}]
		dev-python/trustme[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs/sphinx \
	dev-python/furo \
	dev-python/sphinx-autodoc-typehints
EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# Fails in upstream CI as well as of 8.13.1
		# https://github.com/elastic/elastic-transport-python/commit/39488817cd5da824101322e40652d17938f0acac
		tests/node/test_tls_versions.py::test_unsupported_tls_versions[https://tls-v1-2.badssl.com:1012-772-RequestsHttpNode]
		# fragile to random warnings
		tests/node/test_http_aiohttp.py::TestAiohttpHttpNode::test_uses_https_if_verify_certs_is_off
		tests/node/test_urllib3_chain_certs.py::test_assert_fingerprint_in_cert_chain
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p asyncio -o addopts=
}

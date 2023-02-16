# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Transport classes and utilities shared among Python Elastic client libraries"
HOMEPAGE="
	https://github.com/elastic/elastic-transport-python
	https://pypi.org/project/elastic-transport/
"
SRC_URI="https://github.com/elastic/elastic-transport-python/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-python-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PROPERTIES="test_network"
RESTRICT="test"

RDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.26.2[${PYTHON_USEDEP}] <dev-python/urllib3-2[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		  ${RDEPEND}
		  dev-python/aiohttp[${PYTHON_USEDEP}]
		  dev-python/mock[${PYTHON_USEDEP}]
		  dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		  dev-python/pytest-httpserver[${PYTHON_USEDEP}]
		  dev-python/pytest-mock[${PYTHON_USEDEP}]
		  dev-python/requests[${PYTHON_USEDEP}]
		  dev-python/trustme[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs/sphinx dev-python/furo dev-python/sphinx-autodoc-typehints
distutils_enable_tests pytest

src_prepare() {
	# Remove extra options from tests. Mainly to avoid dependance on coverage
	sed -i '/[tool:pytest]/,/^$/ d' setup.cfg || die
	# Pytest options add more warnings and individually ingoring warnings would be more hassle than worth
	# So lets just remove the bit counting warnings, as the test checks if there is a specific warning eitherway.
	sed -i '/test_uses_https_if_verify_certs_is_off/,/def/ { /assert 1 == len(w)/ d }' \
		tests/node/test_http_aiohttp.py || die

	default
}

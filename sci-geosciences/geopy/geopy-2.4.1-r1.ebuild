# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Python client for several popular geocoding web services"
HOMEPAGE="https://github.com/geopy/geopy"
SRC_URI="https://github.com/geopy/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/geographiclib[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

EPYTEST_PLUGINS=( pytest-asyncio )
distutils_enable_tests pytest

PATCHES=( "${FILESDIR}"/${P}-test.patch )

src_test() {
	local EPYTEST_DESELECT=(
		test/adapters/each_adapter.py::test_geocoder_constructor_uses_https_proxy
		test/adapters/each_adapter.py::test_geocoder_https_proxy_auth_is_respected
		test/adapters/each_adapter.py::test_ssl_context_with
	)
	distutils-r1_src_test
}

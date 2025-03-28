# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
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
BDEPEND="test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_test() {
	local EPYTEST_DESELECT=(
		test/geocoders/nominatim.py::TestNominatim::test_reverse_zoom_parameter
		test/geocoders/photon.py::TestPhoton::test_osm_tag
	)
	distutils-r1_src_test
}

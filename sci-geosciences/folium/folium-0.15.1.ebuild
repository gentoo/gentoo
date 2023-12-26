# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Python Data, Leaflet.js Maps"
HOMEPAGE="https://github.com/python-visualization/folium"
SRC_URI="https://github.com/python-visualization/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-0.12.1-scm.patch
	"${FILESDIR}"/${P}-gentoo.patch
)

RDEPEND="sci-libs/branca[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
	)"
BDEPEND=""

distutils_enable_tests pytest

src_prepare() {
	rm -r tests/selenium || die # require chromedriver
	rm tests/test_folium.py || die # require geopandas
	rm tests/test_raster_layers.py || die # require xyzservices
	rm tests/plugins/test_time_slider_choropleth.py || die # require geopandas
	rm tests/test_repr.py || die # require geckodriver
	default
}

python_test() {
	epytest -m 'not web'
}

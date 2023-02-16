# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Mapbox Vector Tile encoding and decoding."
HOMEPAGE="
	https://github.com/tilezen/mapbox-vector-tile/
	https://pypi.org/project/mapbox-vector-tile/
"
SRC_URI="https://github.com/tilezen/mapbox-vector-tile/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	dev-python/pyclipper[${PYTHON_USEDEP}]
	dev-python/pyproj[${PYTHON_USEDEP}]
	dev-python/shapely[${PYTHON_USEDEP}]
"
BDEPEND="test? ( ${RDEPEND}	)"

distutils_enable_tests unittest

src_prepare() {
	# Dont install into top-level
	sed -Ei '/include = \[/,/\]/ { /(README|CHANGELOG)/d }' pyproject.toml || die
	default
}

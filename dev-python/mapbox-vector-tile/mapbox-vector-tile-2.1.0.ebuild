# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Mapbox Vector Tile encoding and decoding."
HOMEPAGE="
	https://github.com/tilezen/mapbox-vector-tile/
	https://pypi.org/project/mapbox-vector-tile/
"
SRC_URI="https://github.com/tilezen/mapbox-vector-tile/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~x86"

RDEPEND="
	dev-python/protobuf[${PYTHON_USEDEP}]
	>=dev-python/pyclipper-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/pyproj-3.4.1[${PYTHON_USEDEP}]
	>=dev-python/shapely-2.0.0[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

src_prepare() {
	# don't install into top-level
	sed -Ei '/include = \[/,/\]/ { /(README|CHANGELOG)/d }' pyproject.toml || die
	# relax the dep
	sed -i -e '/protobuf/s:\^[0-9.]*:*:' pyproject.toml || die
	distutils-r1_src_prepare
}

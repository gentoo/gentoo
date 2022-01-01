# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9} )
inherit distutils-r1

DESCRIPTION="Python client for several popular geocoding web services"
HOMEPAGE="https://github.com/geopy/geopy"
SRC_URI="${HOMEPAGE}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
# Need geocoding service to test
RESTRICT="test"

RDEPEND="sci-geosciences/GeographicLib[python,${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND=""

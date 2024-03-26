# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Python client for several popular geocoding web services"
HOMEPAGE="https://github.com/geopy/geopy"
SRC_URI="https://github.com/geopy/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
# Need geocoding service to test
RESTRICT="test"

RDEPEND="dev-python/geographiclib[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

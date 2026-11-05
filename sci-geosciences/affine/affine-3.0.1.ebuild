# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
DISTUTILS_USE_PEP517=flit
inherit distutils-r1

DESCRIPTION="Affine transformation matrices"
HOMEPAGE="https://affine.readthedocs.io/en/latest/index.html"
SRC_URI="https://github.com/rasterio/${PN}/archive/refs/tags/${PV}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/attrs[${PYTHON_USEDEP}]"
BDEPEND="test? (
	dev-python/numpy[${PYTHON_USEDEP}]
)"

EPYTEST_PLUGINS=( )
distutils_enable_tests pytest

# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Python 3-D coordinate conversions"
HOMEPAGE="https://github.com/geospace-code/pymap3d"
SRC_URI="https://github.com/geospace-code/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="test? (
	dev-python/xarray
	dev-python/pyproj
)"

distutils_enable_tests pytest

src_prepare() {
	rm src/pymap3d/tests/test_eci.py || die
	default
}

# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
inherit optfeature distutils-r1

DESCRIPTION="Rasterio reads and writes geospatial raster datasets"
HOMEPAGE="https://rasterio.readthedocs.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-geosciences/affine[${PYTHON_USEDEP}]
	sci-libs/gdal:=[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		dev-python/fsspec[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( )
distutils_enable_tests pytest

python_test() {
	rm -rf rasterio || die
	epytest -m "not network"
}

pkg_postinst() {
	optfeature "AWS S3 authentication support" dev-python/boto3
	optfeature "plotting support (rasterio.plot / show())" dev-python/matplotlib
	optfeature "interactive shell support (rio insp)" dev-python/ipython
}

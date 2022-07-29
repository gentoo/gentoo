# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Read and write TIFF files"
HOMEPAGE="
	https://pypi.org/project/tifffile/
	https://github.com/cgohlke/tifffile/
	https://www.lfd.uci.edu/~gohlke/
"
SRC_URI="
	https://github.com/cgohlke/tifffile/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/numpy-1.19.2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/dask[${PYTHON_USEDEP}]
		>=dev-python/fsspec-2021.5.0[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/xarray[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Internet
	tests/test_tifffile.py::test_class_omexml
	tests/test_tifffile.py::test_class_omexml_fail
	tests/test_tifffile.py::test_class_omexml_modulo
	tests/test_tifffile.py::test_class_omexml_attributes
	tests/test_tifffile.py::test_class_omexml_multiimage
	tests/test_tifffile.py::test_write_ome
	tests/test_tifffile.py::test_write_ome_manual
	# requires tons of free space
	tests/test_tifffile.py::test_write_3gb
	tests/test_tifffile.py::test_write_bigtiff
	'tests/test_tifffile.py::test_write_imagej_raw'
)

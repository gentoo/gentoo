# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Python interface to the PROJ library"
HOMEPAGE="https://github.com/pyproj4/pyproj"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P/_p/.post}.tar.gz"
S="${WORKDIR}/${P/_p/.post}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"

RDEPEND=">=sci-libs/proj-7.2.0:="
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/xarray[${PYTHON_USEDEP}]
		sci-libs/shapely[${PYTHON_USEDEP}]
	)"

distutils_enable_sphinx docs dev-python/sphinx_rtd_theme
distutils_enable_tests --install pytest

python_test() {
	local deselect=(
		# TODO
		test/test_datum.py
		test/test_transformer.py::test_transform_wgs84_to_alaska
		test/test_transformer.py::test_repr__conditional
		test/test_transformer.py::test_transformer_group__unavailable
		test/test_transformer.py::test_transformer_group__network_disabled
		test/test_transformer.py::test_transformer_group__download_grids__directory
		test/crs/test_crs.py::test_coordinate_operation_grids__alternative_grid_name
	)

	distutils_install_for_testing
	pytest -vv --import-mode=append -m "not network" \
		${deselect[@]/#/--deselect } test ||
		die "Tests failed with ${EPYTHON}"
}

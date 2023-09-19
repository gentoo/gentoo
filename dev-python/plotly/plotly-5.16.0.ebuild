# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

MY_P=plotly.py-${PV}
DESCRIPTION="Browser-based graphing library for Python"
HOMEPAGE="
	https://plotly.com/python/
	https://github.com/plotly/plotly.py/
	https://pypi.org/project/plotly/
"
SRC_URI="
	https://github.com/plotly/plotly.py/archive/refs/tags/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S="${WORKDIR}/${MY_P}/packages/python/plotly"
# The tests are not included in the PyPI tarball, to use the GitHub tarball
# we have to skip npm, which means that the resulting install will
# unfortunately lack the jupyterlab extension.

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/tenacity-6.2.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/ipykernel[${PYTHON_USEDEP}]
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/ipywidgets[${PYTHON_USEDEP}]
		dev-python/jupyter[${PYTHON_USEDEP}]
		dev-python/jupyterlab[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/shapely[${PYTHON_USEDEP}]
		dev-python/statsmodels[${PYTHON_USEDEP}]
		dev-python/xarray[${PYTHON_USEDEP}]
		sci-libs/scikit-image[${PYTHON_USEDEP}]
	)
"

# README ends up a broken symlink
DOCS=()

PATCHES=(
	"${FILESDIR}"/${PN}-5.8.0-fix-versioneer-import.patch
)

EPYTEST_IGNORE=(
	# Needs porting to newer numpy
	_plotly_utils/tests/validators/test_integer_validator.py

	# kaleido not packaged
	plotly/tests/test_optional/test_kaleido

	# plotly-orca not packaged
	plotly/tests/test_orca
)

EPYTEST_DESELECT=(
	# Also needs porting to newer numpy
	plotly/tests/test_io/test_to_from_plotly_json.py::test_object_numpy_encoding

	# kaleido not packaged
	plotly/tests/test_orca/test_to_image.py::test_bytesio

	# Fails if not already installed
	test_init/test_dependencies_not_imported.py::test_dependencies_not_imported
	test_init/test_lazy_imports.py::test_lazy_imports

	# Minor matplotlib incompatibility
	plotly/matplotlylib/mplexporter/tests/test_basic.py::test_path_collection
	plotly/matplotlylib/mplexporter/tests/test_basic.py::test_legend_dots
	plotly/matplotlylib/mplexporter/tests/test_utils.py::test_linestyle

	# In python 3.11 the produced error is slightly different
	plotly/tests/test_core/test_errors/test_dict_path_errors.py::test_described_subscript_error_on_type_error

	# TODO
	plotly/tests/test_io/test_to_from_plotly_json.py

	# two subtests that require 'vaex' and 'polars' respectively
	plotly/tests/test_optional/test_px/test_px_input.py::test_build_df_from_vaex_and_polars
)

# There are sphinx docs but we are missing a bunch of dependencies.
# distutils_enable_sphinx ../../../doc/apidoc
distutils_enable_tests pytest

python_prepare_all() {
	# Do not try to fetch stuff with npm
	export SKIP_NPM=1
	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all

	mv "${ED}"/{usr/etc,etc} || die
}

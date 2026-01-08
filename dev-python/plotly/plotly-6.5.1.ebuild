# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

MY_P=plotly.py-${PV/_}
DESCRIPTION="Browser-based graphing library for Python"
HOMEPAGE="
	https://plotly.com/python/
	https://github.com/plotly/plotly.py/
	https://pypi.org/project/plotly/
"
SRC_URI="
	https://github.com/plotly/plotly.py/archive/refs/tags/v${PV/_}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S="${WORKDIR}/${MY_P}"
# The tests are not included in the PyPI tarball, to use the GitHub tarball
# we have to skip npm, which means that the resulting install will
# unfortunately lack the jupyterlab extension.

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-python/narwhals-1.15.1[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/jupyter[${PYTHON_USEDEP}]
		dev-python/jupyterlab[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/scikit-image[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/statsmodels[${PYTHON_USEDEP}]
		dev-python/xarray[${PYTHON_USEDEP}]
	)
"

# There are sphinx docs but we are missing a bunch of dependencies.
# distutils_enable_sphinx ../../../doc/apidoc

EPYTEST_PLUGINS=()
# xdist is causing pretty nasty race conditions here
distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# requires polars
	tests/test_optional/test_px

	# requires kaleido
	tests/test_optional/test_kaleido/test_kaleido.py
)

EPYTEST_DESELECT=(
	# requires polars
	'tests/test_plotly_utils/validators/test_fig_deepcopy.py::test_deepcopy_dataframe[polars]'

	# require anywidgets
	'tests/test_io/test_to_from_json.py::test_from_json_output_type[FigureWidget-FigureWidget0]'
	'tests/test_io/test_to_from_json.py::test_from_json_output_type[FigureWidget-FigureWidget1]'
	'tests/test_io/test_to_from_json.py::test_read_json_from_filelike[FigureWidget-FigureWidget0]'
	'tests/test_io/test_to_from_json.py::test_read_json_from_filelike[FigureWidget-FigureWidget1]'
	'tests/test_io/test_to_from_json.py::test_read_json_from_pathlib[FigureWidget-FigureWidget0]'
	'tests/test_io/test_to_from_json.py::test_read_json_from_pathlib[FigureWidget-FigureWidget1]'
	'tests/test_io/test_to_from_json.py::test_read_json_from_file_string[FigureWidget-FigureWidget0]'
	'tests/test_io/test_to_from_json.py::test_read_json_from_file_string[FigureWidget-FigureWidget1]'

	# minor matplotlib incompatibility
	plotly/matplotlylib/mplexporter/tests/test_basic.py::test_legend_dots
	plotly/matplotlylib/mplexporter/tests/test_utils.py::test_linestyle

	# fails in non-isolated env
	test_init/test_dependencies_not_imported.py::test_dependencies_not_imported
	test_init/test_lazy_imports.py::test_lazy_imports

	# TODO
	'tests/test_plotly_utils/validators/test_colorscale_validator.py::test_acceptance_named[Inferno_r]'

	# numpy 2.4
	tests/test_optional/test_figure_factory/test_figure_factory.py::TestViolin::test_violin_fig
	tests/test_optional/test_utils/test_utils.py::TestJSONEncoder::test_encode_customdata_datetime_homogeneous_dataframe
	tests/test_optional/test_utils/test_utils.py::TestJSONEncoder::test_encode_customdata_datetime_series
	tests/test_optional/test_utils/test_utils.py::TestJSONEncoder::test_numpy_datetime64
)

src_configure() {
	# Do not try to fetch stuff with npm
	export SKIP_NPM=1
}

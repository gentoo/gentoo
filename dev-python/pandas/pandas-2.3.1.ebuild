# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=meson-python
PYTHON_COMPAT=( python3_{11..13} )
PYTHON_REQ_USE="threads(+)"

VIRTUALX_REQUIRED="manual"

inherit distutils-r1 optfeature pypi toolchain-funcs virtualx

DESCRIPTION="Powerful data structures for data analysis and statistics"
HOMEPAGE="
	https://pandas.pydata.org/
	https://github.com/pandas-dev/pandas/
	https://pypi.org/project/pandas/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 arm64 ~riscv ~x86"
IUSE="big-endian full-support minimal test X"
RESTRICT="!test? ( test )"

RECOMMENDED_DEPEND="
	>=dev-python/bottleneck-1.3.4[${PYTHON_USEDEP}]
	>=dev-python/numexpr-2.8.0[${PYTHON_USEDEP}]
"

# TODO: add pandas-gbq to the tree
# TODO: Re-add dev-python/statsmodel[python3_11] dep once it supports python3_11
# https://github.com/statsmodels/statsmodels/issues/8287
OPTIONAL_DEPEND="
	>=dev-python/beautifulsoup4-4.11.1[${PYTHON_USEDEP}]
	dev-python/blosc[${PYTHON_USEDEP}]
	>=dev-python/html5lib-1.1[${PYTHON_USEDEP}]
	>=dev-python/jinja2-3.1.2[${PYTHON_USEDEP}]
	>=dev-python/lxml-4.8.0[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-3.6.1[${PYTHON_USEDEP}]
	>=dev-python/openpyxl-3.0.7[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-1.4.36[${PYTHON_USEDEP}]
	>=dev-python/tabulate-0.8.10[${PYTHON_USEDEP}]
	>=dev-python/xarray-2022.3.0[${PYTHON_USEDEP}]
	>=dev-python/xlrd-2.0.1[${PYTHON_USEDEP}]
	>=dev-python/xlsxwriter-3.0.3[${PYTHON_USEDEP}]
	>=dev-python/xlwt-1.3.0[${PYTHON_USEDEP}]
	!arm? ( !hppa? ( !ppc? ( !x86? (
		>=dev-python/scipy-1.8.1[${PYTHON_USEDEP}]
		dev-python/statsmodels[${PYTHON_USEDEP}]
	) ) ) )
	!big-endian? (
		>=dev-python/tables-3.7.0[${PYTHON_USEDEP}]
	)
	X? (
		|| (
			>=dev-python/pyqt5-5.15.6[${PYTHON_USEDEP}]
			>=dev-python/qtpy-2.2.0[${PYTHON_USEDEP}]
			x11-misc/xclip
			x11-misc/xsel
		)
	)
"
DEPEND="
	>=dev-python/numpy-1.23.2:=[${PYTHON_USEDEP}]
"
COMMON_DEPEND="
	${DEPEND}
	>=dev-python/python-dateutil-2.8.2[${PYTHON_USEDEP}]
	>=dev-python/pytz-2020.1[${PYTHON_USEDEP}]
"
BDEPEND="
	${COMMON_DEPEND}
	>=dev-build/meson-1.2.1
	>=dev-python/cython-3.0.5[${PYTHON_USEDEP}]
	>=dev-python/versioneer-0.28[${PYTHON_USEDEP}]
	test? (
		${VIRTUALX_DEPEND}
		${RECOMMENDED_DEPEND}
		${OPTIONAL_DEPEND}
		dev-libs/apache-arrow[brotli,parquet,snappy]
		>=dev-python/beautifulsoup4-4.11.1[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-6.46.1[${PYTHON_USEDEP}]
		>=dev-python/openpyxl-3.0.10[${PYTHON_USEDEP}]
		>=dev-python/pyarrow-10.0.1[parquet,${PYTHON_USEDEP}]
		>=dev-python/pymysql-1.0.2[${PYTHON_USEDEP}]
		>=dev-python/xlsxwriter-3.0.3[${PYTHON_USEDEP}]
		x11-misc/xclip
		x11-misc/xsel
	)
"
RDEPEND="
	${COMMON_DEPEND}
	dev-python/tzdata[${PYTHON_USEDEP}]
	!minimal? ( ${RECOMMENDED_DEPEND} )
	full-support? ( ${OPTIONAL_DEPEND} )
"

EPYTEST_PLUGINS=()
EPYTEST_XDIST=1
distutils_enable_tests pytest

PATCHES=(
	# https://github.com/pandas-dev/pandas/pull/61331/commits/12b1d00622ffc8b99986da2f4478cc2df4da213a
	# (partially applied to 2.3.1, sigh)
	"${FILESDIR}/${P}-xarray-test.patch"
)

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	# Note; deselects relative to pandas/
	local EPYTEST_DESELECT=(
		# test for rounding errors, fails if we have better precision
		# e.g. on amd64 with FMA or on arm64
		# https://github.com/pandas-dev/pandas/issues/38921
		tests/window/test_rolling.py::test_rolling_var_numerical_issues

		# TODO: missing data not covered by --no-strict-data-files?
		tests/io/xml/test_xml.py::test_empty_stylesheet
		tests/io/xml/test_xml.py::test_wrong_file_path

		# deprecation warning
		'tests/computation/test_eval.py::TestEval::test_scalar_unary[numexpr-pandas]'

		# requires -Werror
		tests/tslibs/test_to_offset.py::test_to_offset_lowercase_frequency_deprecated
		tests/tslibs/test_to_offset.py::test_to_offset_uppercase_frequency_deprecated
		tests/copy_view/test_array.py::test_dataframe_multiple_numpy_dtypes

		# probably pytz, doesn't happen on main (where zoneinfo is used)
		'tests/arrays/test_array.py::test_array_inference[data7-expected7]'

		# virtx?
		pandas/tests/test_downstream.py::test_seaborn
	)

	if ! tc-has-64bit-time_t; then
		EPYTEST_DESELECT+=(
			# Needs 64-bit time_t (TODO: split into 32-bit arch only section)
			tests/tseries/offsets/test_year.py::test_add_out_of_pydatetime_range
			'tests/tseries/offsets/test_common.py::test_apply_out_of_range[tzlocal()-BusinessDay]'
			'tests/tseries/offsets/test_common.py::test_apply_out_of_range[tzlocal()-BusinessHour]'
			'tests/tseries/offsets/test_common.py::test_apply_out_of_range[tzlocal()-BusinessMonthEnd]'
			'tests/tseries/offsets/test_common.py::test_apply_out_of_range[tzlocal()-BusinessMonthBegin]'
			'tests/tseries/offsets/test_common.py::test_apply_out_of_range[tzlocal()-BQuarterEnd]'
			'tests/tseries/offsets/test_common.py::test_apply_out_of_range[tzlocal()-BQuarterBegin]'
			'tests/tseries/offsets/test_common.py::test_apply_out_of_range[tzlocal()-CustomBusinessDay]'
			'tests/tseries/offsets/test_common.py::test_apply_out_of_range[tzlocal()-CustomBusinessHour]'
			'tests/tseries/offsets/test_common.py::test_apply_out_of_range[tzlocal()-CustomBusinessMonthEnd]'
			'tests/tseries/offsets/test_common.py::test_apply_out_of_range[tzlocal()-CustomBusinessMonthBegin]'
			'tests/tseries/offsets/test_common.py::test_apply_out_of_range[tzlocal()-MonthEnd]'
			'tests/tseries/offsets/test_common.py::test_apply_out_of_range[tzlocal()-MonthBegin]'
			'tests/tseries/offsets/test_common.py::test_apply_out_of_range[tzlocal()-SemiMonthBegin]'
			'tests/tseries/offsets/test_common.py::test_apply_out_of_range[tzlocal()-SemiMonthEnd]'
			'tests/tseries/offsets/test_common.py::test_apply_out_of_range[tzlocal()-QuarterEnd]'
			'tests/tseries/offsets/test_common.py::test_apply_out_of_range[tzlocal()-LastWeekOfMonth]'
			'tests/tseries/offsets/test_common.py::test_apply_out_of_range[tzlocal()-WeekOfMonth]'
			'tests/tseries/offsets/test_common.py::test_apply_out_of_range[tzlocal()-Week]'
		)
	fi

	if ! has_version "dev-python/scipy[${PYTHON_USEDEP}]"; then
		EPYTEST_DESELECT+=(
			tests/plotting/test_misc.py::test_savefig
		)
	fi

	local -x LC_ALL=C.UTF-8
	cd "${BUILD_DIR}/install$(python_get_sitedir)" || die
	"${EPYTHON}" -c "import pandas; pandas.show_versions()" || die
	# nonfatal from virtx
	# --no-strict-data-files is necessary since upstream prevents data
	# files from even being included in GitHub archives, sigh
	# https://github.com/pandas-dev/pandas/issues/54907
	nonfatal epytest pandas/tests \
		--no-strict-data-files -o xfail_strict=false \
		-m "not single_cpu and not slow and not network and not db" ||
		die "Tests failed with ${EPYTHON}"
	rm test_stata.dta || die
}

pkg_postinst() {
	optfeature "accelerating certain types of NaN evaluations, using specialized cython routines to achieve large speedups." dev-python/bottleneck
	optfeature "accelerating certain numerical operations, using multiple cores as well as smart chunking and caching to achieve large speedups" ">=dev-python/numexpr-2.1"
	optfeature "needed for pandas.io.html.read_html" dev-python/beautifulsoup4 dev-python/html5lib dev-python/lxml
	optfeature "for msgpack compression using blosc" dev-python/blosc
	optfeature "Template engine for conditional HTML formatting" dev-python/jinja2
	optfeature "Plotting support" dev-python/matplotlib
	optfeature "Needed for Excel I/O" ">=dev-python/openpyxl-3.0.10" dev-python/xlsxwriter dev-python/xlrd dev-python/xlwt
	optfeature "necessary for HDF5-based storage" ">=dev-python/tables-3.7.0"
	optfeature "R I/O support" dev-python/rpy2
	optfeature "Needed for parts of pandas.stats" dev-python/statsmodels
	optfeature "SQL database support" ">=dev-python/sqlalchemy-1.4.36"
	optfeature "miscellaneous statistical functions" dev-python/scipy
	optfeature "necessary to use pandas.io.clipboard.read_clipboard support" dev-python/pyqt5 dev-python/qtpy dev-python/pygtk x11-misc/xclip x11-misc/xsel
}

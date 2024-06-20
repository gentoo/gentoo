# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="N-D labeled arrays and datasets in Python"
HOMEPAGE="
	https://xarray.pydata.org/
	https://github.com/pydata/xarray/
	https://pypi.org/project/xarray/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ~loong ~riscv x86"
IUSE="big-endian"

RDEPEND="
	<dev-python/numpy-2[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.23[${PYTHON_USEDEP}]
	>=dev-python/pandas-2.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-23.1[${PYTHON_USEDEP}]
"
# note: most of the test dependencies are optional
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/bottleneck[${PYTHON_USEDEP}]
		dev-python/cftime[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/toolz[${PYTHON_USEDEP}]
		!hppa? ( >=dev-python/scipy-1.4[${PYTHON_USEDEP}] )
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=()
	if ! has_version ">=dev-python/scipy-1.4[${PYTHON_USEDEP}]" ; then
		EPYTEST_DESELECT+=(
			'xarray/tests/test_missing.py::test_interpolate_na_2d[coords1]'
		)

		if ! has_version "dev-python/scipy[${PYTHON_USEDEP}]" ; then
			EPYTEST_DESELECT+=(
				xarray/tests/test_calendar_ops.py::test_interp_calendar
			)
		fi
	fi

	if use big-endian ; then
		EPYTEST_DESELECT+=(
			# Appears to be a numpy issue in display? See bug #916460.
			'xarray/tests/test_coding_times.py::test_roundtrip_datetime64_nanosecond_precision[1677-09-21T00:12:43.145224193-ns-int64-20-True]'
			'xarray/tests/test_coding_times.py::test_roundtrip_datetime64_nanosecond_precision[1970-09-21T00:12:44.145224808-ns-float64-1e+30-True]'
			'xarray/tests/test_coding_times.py::test_roundtrip_datetime64_nanosecond_precision[1677-09-21T00:12:43.145225216-ns-float64--9.223372036854776e+18-True]'
			'xarray/tests/test_coding_times.py::test_roundtrip_datetime64_nanosecond_precision[1677-09-21T00:12:43.145224193-ns-int64-None-False]'
			'xarray/tests/test_coding_times.py::test_roundtrip_datetime64_nanosecond_precision[1677-09-21T00:12:43.145225-us-int64-None-False]'
			'xarray/tests/test_coding_times.py::test_roundtrip_datetime64_nanosecond_precision[1970-01-01T00:00:01.000001-us-int64-None-False]'
			'xarray/tests/test_coding_times.py::test_roundtrip_datetime64_nanosecond_precision[1677-09-21T00:21:52.901038080-ns-float32-20.0-True]'
		)
	fi

	if [[ ${ABI} != *64* ]]; then
		EPYTEST_DESELECT+=(
			# these tests hardcode object sizes for 64-bit arches
			# https://github.com/pydata/xarray/issues/9127
			xarray/tests/test_dataarray.py::TestDataArray::test_repr_multiindex
			xarray/tests/test_dataarray.py::TestDataArray::test_repr_multiindex_long
			xarray/tests/test_dataset.py::TestDataset::test_repr_multiindex
			xarray/tests/test_formatting.py::test_array_repr_dtypes_unix
		)
	fi

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

# TODO: switch back to pypi in the next release
MY_PV=2024.03.0
MY_P=${PN}-${MY_PV}

DESCRIPTION="N-D labeled arrays and datasets in Python"
HOMEPAGE="
	https://xarray.pydata.org/
	https://github.com/pydata/xarray/
	https://pypi.org/project/xarray/
"
SRC_URI="
	https://github.com/pydata/xarray/archive/v${MY_PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ~hppa ~loong ~riscv x86"
IUSE="big-endian"

RDEPEND="
	<dev-python/numpy-2[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.23[${PYTHON_USEDEP}]
	>=dev-python/pandas-1.5[${PYTHON_USEDEP}]
	>=dev-python/packaging-22[${PYTHON_USEDEP}]
"
# note: most of the test dependencies are optional
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/bottleneck[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/toolz[${PYTHON_USEDEP}]
		!hppa? ( >=dev-python/scipy-1.4[${PYTHON_USEDEP}] )
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# requires dev-python/cftime
		'xarray/tests/test_coding_times.py::test_encode_cf_datetime_datetime64_via_dask[mixed-cftime-pandas-encoding-with-prescribed-units-and-dtype]'
	)
	if ! has_version ">=dev-python/scipy-1.4[${PYTHON_USEDEP}]" ; then
		EPYTEST_DESELECT+=(
			'xarray/tests/test_missing.py::test_interpolate_na_2d[coords1]'
		)
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

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}

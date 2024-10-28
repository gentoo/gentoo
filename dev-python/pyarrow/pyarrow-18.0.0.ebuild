# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 multiprocessing

# arrow.git: testing
ARROW_DATA_GIT_HASH=4d209492d514c2d3cb2d392681b9aa00e6d8da1c
# arrow.git: cpp/submodules/parquet-testing
PARQUET_DATA_GIT_HASH=cb7a9674142c137367bf75a01b79c6e214a73199

DESCRIPTION="Python library for Apache Arrow"
HOMEPAGE="
	https://arrow.apache.org/
	https://github.com/apache/arrow/
	https://pypi.org/project/pyarrow/
"
SRC_URI="
	mirror://apache/arrow/arrow-${PV}/apache-arrow-${PV}.tar.gz
	test? (
		https://github.com/apache/parquet-testing/archive/${PARQUET_DATA_GIT_HASH}.tar.gz
			-> parquet-testing-${PARQUET_DATA_GIT_HASH}.tar.gz
		https://github.com/apache/arrow-testing/archive/${ARROW_DATA_GIT_HASH}.tar.gz
			-> arrow-testing-${ARROW_DATA_GIT_HASH}.tar.gz
	)
"
S="${WORKDIR}/apache-arrow-${PV}/python"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE="+parquet +snappy ssl"

RDEPEND="
	~dev-libs/apache-arrow-${PV}[compute,dataset,json,parquet?,re2,snappy?,ssl?]
	>=dev-python/numpy-1.16.6:=[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/cffi[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		dev-libs/apache-arrow[lz4,zlib]
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# cython's -Werror
	sed -i -e '/--warning-errors/d' CMakeLists.txt || die
}

src_compile() {
	export PYARROW_PARALLEL="$(makeopts_jobs)"
	export PYARROW_BUILD_VERBOSE=1
	export PYARROW_CXXFLAGS="${CXXFLAGS}"
	export PYARROW_BUNDLE_ARROW_CPP_HEADERS=0
	export PYARROW_CMAKE_GENERATOR=Ninja
	export PYARROW_WITH_HDFS=1
	if use parquet; then
		export PYARROW_WITH_DATASET=1
		export PYARROW_WITH_PARQUET=1
		use ssl && export PYARROW_WITH_PARQUET_ENCRYPTION=1
	fi
	if use snappy; then
		export PYARROW_WITH_SNAPPY=1
	fi

	distutils-r1_src_compile
}

python_test() {
	local EPYTEST_DESELECT=(
		# wtf?
		tests/test_fs.py::test_localfs_errors
		# these require apache-arrow with jemalloc that doesn't seem
		# to be supported by the Gentoo package
		tests/test_memory.py::test_env_var
		tests/test_memory.py::test_specific_memory_pools
		tests/test_memory.py::test_supported_memory_backends
		# hypothesis health check failures
		# https://github.com/apache/arrow/issues/41318
		tests/interchange/test_interchange_spec.py::test_dtypes
		tests/test_convert_builtin.py::test_array_to_pylist_roundtrip
		tests/test_feather.py::test_roundtrip
		tests/test_pandas.py::test_array_to_pandas_roundtrip
		tests/test_strategies.py::test_types
		tests/test_types.py::test_hashing
		# fragile memory tests
		tests/test_csv.py::TestSerialStreamingCSVRead::test_batch_lifetime
		tests/test_csv.py::TestThreadedStreamingCSVRead::test_batch_lifetime
		# takes forever, and manages to generate timedeltas over 64 bits
		tests/test_strategies.py
	)

	cd "${T}" || die
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PARQUET_TEST_DATA="${WORKDIR}/parquet-testing-${PARQUET_DATA_GIT_HASH}/data"
	local -x ARROW_TEST_DATA="${WORKDIR}/arrow-testing-${ARROW_DATA_GIT_HASH}/data"
	epytest --pyargs pyarrow
}

# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 multiprocessing

DESCRIPTION="Python library for Apache Arrow"
HOMEPAGE="
	https://arrow.apache.org/
	https://github.com/apache/arrow/
	https://pypi.org/project/pyarrow/
"
SRC_URI="mirror://apache/arrow/arrow-${PV}/apache-arrow-${PV}.tar.gz"
S="${WORKDIR}/apache-arrow-${PV}/python"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~loong ~riscv ~x86"
IUSE="+parquet +snappy ssl"

RDEPEND="
	~dev-libs/apache-arrow-${PV}[compute,dataset,json,parquet?,re2,snappy?,ssl?]
	>=dev-python/numpy-1.16.6:=[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-libs/apache-arrow[lz4,zlib]
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

src_prepare() {
	local PATCHES=(
		# https://github.com/apache/arrow/pull/42099
		"${FILESDIR}/${P}-numpy-2.patch"
		# https://github.com/apache/arrow/pull/42034
		"${FILESDIR}/${P}-py313.patch"
	)

	# cython's -Werror
	sed -i -e '/--warning-errors/d' CMakeLists.txt || die
	distutils-r1_src_prepare
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
		# pandas changed, i guess
		tests/test_pandas.py::test_array_protocol_pandas_extension_types
		tests/test_table.py::test_table_factory_function_args_pandas
		# hypothesis health check failures
		# https://github.com/apache/arrow/issues/41318
		tests/interchange/test_interchange_spec.py::test_dtypes
		tests/test_convert_builtin.py::test_array_to_pylist_roundtrip
		tests/test_feather.py::test_roundtrip
		tests/test_pandas.py::test_array_to_pandas_roundtrip
		tests/test_types.py::test_hashing
	)

	cd "${T}" || die
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest --pyargs pyarrow
}

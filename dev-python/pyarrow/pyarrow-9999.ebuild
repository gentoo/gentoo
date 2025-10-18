# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 git-r3 multiprocessing

DESCRIPTION="Python library for Apache Arrow"
HOMEPAGE="
	https://arrow.apache.org/
	https://github.com/apache/arrow/
	https://pypi.org/project/pyarrow/
"
EGIT_REPO_URI="https://github.com/apache/arrow.git"
EGIT_SUBMODULES=( '*' )
S="${WORKDIR}/${P}/python"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="+parquet +snappy ssl"

RDEPEND="
	~dev-libs/apache-arrow-${PV}[compute,dataset,json,parquet?,re2,snappy?,ssl?]
	>=dev-python/numpy-1.16.6:=[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/cffi[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		dev-libs/apache-arrow[lz4,zlib]
	)
"

EPYTEST_PLUGINS=( hypothesis )
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
		# require mimalloc
		tests/test_memory.py::test_memory_pool_factories
		# fragile memory tests
		tests/test_csv.py::TestSerialStreamingCSVRead::test_batch_lifetime
		tests/test_csv.py::TestThreadedStreamingCSVRead::test_batch_lifetime
		# takes forever, and manages to generate timedeltas over 64 bits
		tests/test_strategies.py
		"tests/test_array.py::test_pickling[builtin_pickle]"
		# scipy.sparse does not support dtype float16
		"tests/test_sparse_tensor.py::test_sparse_coo_tensor_scipy_roundtrip[f2-arrow_type8]"
	)

	cd "${T}" || die
	local -x PARQUET_TEST_DATA="${WORKDIR}/${P}/cpp/submodules/parquet-testing/data"
	local -x ARROW_TEST_DATA="${WORKDIR}/${P}/testing/data"
	epytest --pyargs pyarrow
}

# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1 multiprocessing

DESCRIPTION="Python library for Apache Arrow"
HOMEPAGE="
	https://pypi.org/project/pyarrow/
	https://arrow.apache.org/
"
SRC_URI="mirror://apache/arrow/arrow-${PV}/apache-arrow-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="parquet snappy ssl"

RDEPEND="
	~dev-libs/apache-arrow-${PV}[compute,dataset,json,parquet?,snappy?,ssl?]
	dev-python/numpy[${PYTHON_USEDEP}]
"
BDEPEND="test? (
	dev-python/hypothesis
	<dev-python/pandas-2
	dev-python/pytest-lazy-fixture
)"

PATCHES=( "${FILESDIR}"/${P}-tests.patch )

distutils_enable_tests pytest

S="${WORKDIR}/apache-arrow-${PV}/python"

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
	cd "${T}" || die
	epytest --pyargs pyarrow
}

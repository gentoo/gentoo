# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1 virtualx

DESCRIPTION="Library for manipulating TrueType, OpenType, AFM and Type1 fonts"
HOMEPAGE="
	https://github.com/fonttools/fonttools/
	https://pypi.org/project/fonttools/
"
SRC_URI="
	https://github.com/fonttools/fonttools/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="+native-extensions"

BDEPEND="
	native-extensions? (
		dev-python/cython[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/brotlicffi[${PYTHON_USEDEP}]
		dev-python/munkres[${PYTHON_USEDEP}]
		app-arch/zopfli
	)
"

EPYTEST_PLUGINS=( pytest-rerunfailures )
# woff2 tests are extremely flaky
EPYTEST_RERUNS=20
EPYTEST_XDIST=1
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# length mismatches; possibly zlib-ng?
	Tests/ttLib/woff2_test.py::WOFF2ReaderTTFTest::test_table_tags
	Tests/ttLib/woff2_test.py::WOFF2WriterTest::test_calcTotalSize_no_flavorData
	Tests/ttLib/woff2_test.py::WOFF2WriterTest::test_calcTotalSize_with_metaData
	Tests/ttLib/woff2_test.py::WOFF2WriterTest::test_calcTotalSize_with_metaData_and_privData
	Tests/ttLib/woff2_test.py::WOFF2WriterTest::test_calcTotalSize_with_privData
	Tests/ttLib/woff2_test.py::WOFF2WriterTest::test_checksums
	Tests/ttLib/woff2_test.py::WOFF2WriterTest::test_head_transform_flag
	Tests/ttLib/woff2_test.py::WOFF2WriterTest::test_hmtx_trasform
	Tests/ttLib/woff2_test.py::WOFF2WriterTest::test_no_transforms
)

python_compile() {
	local -x FONTTOOLS_WITH_CYTHON=$(usex native-extensions)
	distutils-r1_python_compile
}

src_test() {
	# virtualx used when matplotlib is installed causing plot module tests to run
	virtx distutils-r1_src_test
}

python_test() {
	# nonfatal for virtx
	nonfatal epytest Tests fontTools ||
		die -n "Tests failed with ${EPYTHON}"
}

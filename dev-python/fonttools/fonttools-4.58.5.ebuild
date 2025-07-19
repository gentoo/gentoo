# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..13} )
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
KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="+native-extensions"

RDEPEND="
	>=dev-python/fs-2.4.9[${PYTHON_USEDEP}]
"
BDEPEND="
	native-extensions? (
		$(python_gen_cond_dep '
			dev-python/cython[${PYTHON_USEDEP}]
		' 'python*')
	)
	test? (
		dev-python/brotlicffi[${PYTHON_USEDEP}]
		dev-python/munkres[${PYTHON_USEDEP}]
		app-arch/zopfli
	)
"

EPYTEST_PLUGINS=( pytest-rerunfailures )
EPYTEST_XDIST=1
distutils_enable_tests pytest

python_compile() {
	local -x FONTTOOLS_WITH_CYTHON=$(usex native-extensions)
	[[ ${EPYTHON} == pypy3 ]] && FONTTOOLS_WITH_CYTHON=0
	distutils-r1_python_compile
}

src_test() {
	# virtualx used when matplotlib is installed causing plot module tests to run
	virtx distutils-r1_src_test
}

python_test() {
	local EPYTEST_DESELECT=(
		# flaky test
		Tests/ttLib/woff2_test.py::WOFF2ReaderTest::test_get_normal_tables
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	nonfatal epytest --reruns=5 Tests fontTools ||
		die -n "Tests failed with ${EPYTHON}"
}

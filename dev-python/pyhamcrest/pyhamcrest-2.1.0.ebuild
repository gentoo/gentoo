# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1

MY_P="PyHamcrest-${PV}"
DESCRIPTION="Hamcrest framework for matcher objects"
HOMEPAGE="
	https://github.com/hamcrest/PyHamcrest/
	https://pypi.org/project/PyHamcrest/
"
SRC_URI="
	https://github.com/hamcrest/PyHamcrest/archive/V${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"
IUSE="examples"

BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
"

distutils_enable_sphinx doc \
	dev-python/sphinx-rtd-theme
distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

python_test() {
	local EPYTEST_DESELECT=(
		# removed in numpy 2.0, https://github.com/hamcrest/PyHamcrest/pull/248
		tests/hamcrest_unit_test/number/iscloseto_test.py::IsNumericTest::test_numpy_numeric_type_complex
		tests/hamcrest_unit_test/number/iscloseto_test.py::IsNumericTest::test_numpy_numeric_type_float
	)
	[[ ${EPYTHON} == python3.14 ]] && EPYTEST_DESELECT+=(
		# assumes asyncio event loop already exists
		tests/hamcrest_unit_test/core/future_test.py::FutureExceptionTest
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}

python_install_all() {
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}

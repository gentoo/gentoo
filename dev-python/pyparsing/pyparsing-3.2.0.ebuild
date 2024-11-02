# Copyright 2004-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 8 -- sys-apps/portage dep
EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Easy-to-use Python module for text parsing"
HOMEPAGE="
	https://github.com/pyparsing/pyparsing/
	https://pypi.org/project/pyparsing/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="examples"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_IGNORE=(
		# railroad-diagrams not packaged (and not suitable for packaging yet)
		tests/test_diagram.py
	)
	local EPYTEST_DESELECT=(
		# also railroad-diagrams
		tests/test_examples.py::TestExamples::test_range_check
		tests/test_examples.py::TestExamples::test_rosettacode
		tests/test_unit.py::Test02_WithoutPackrat::testEmptyExpressionsAreHandledProperly
		tests/test_unit.py::Test04_WithPackrat::testEmptyExpressionsAreHandledProperly
		tests/test_unit.py::Test06_WithBoundedPackrat::testEmptyExpressionsAreHandledProperly
		tests/test_unit.py::Test08_WithUnboundedPackrat::testEmptyExpressionsAreHandledProperly
		tests/test_unit.py::Test09_WithLeftRecursionParsing::testEmptyExpressionsAreHandledProperly
		tests/test_unit.py::Test10_WithLeftRecursionParsingBoundedMemo::testEmptyExpressionsAreHandledProperly
	)

	if ! has_version "dev-python/matplotlib[${PYTHON_USEDEP}]"; then
		EPYTEST_IGNORE+=(
			tests/test_matplotlib_cases.py
		)
	fi

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}

python_install_all() {
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples
	fi
	distutils-r1_python_install_all
}

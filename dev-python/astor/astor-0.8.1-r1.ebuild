# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Read/rewrite/write Python ASTs"
HOMEPAGE="
	https://pypi.org/project/astor/
	https://github.com/berkerpeksag/astor/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

PATCHES=(
	"${FILESDIR}"/${P}-tests-bigint.patch
)

distutils_enable_tests pytest

python_test() {
	local EPYTEST_IGNORE=(
		tests/test_rtrip.py
	)
	local EPYTEST_DESELECT=()

	case ${EPYTHON} in
		python3.14)
			EPYTEST_DESELECT+=(
				# TODO
				tests/test_code_gen.py::CodegenTestCase::test_complex
				tests/test_code_gen.py::CodegenTestCase::test_deprecated_constant_nodes
				tests/test_code_gen.py::CodegenTestCase::test_deprecated_name_constants
				tests/test_code_gen.py::CodegenTestCase::test_fstring_debugging
				tests/test_code_gen.py::CodegenTestCase::test_fstring_escaped_braces
				tests/test_code_gen.py::CodegenTestCase::test_fstring_trailing_newline
				tests/test_code_gen.py::CodegenTestCase::test_fstrings
				tests/test_code_gen.py::CodegenTestCase::test_huge_int
				tests/test_code_gen.py::CodegenTestCase::test_inf
				tests/test_code_gen.py::CodegenTestCase::test_nan
			)
			;;
	esac

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}

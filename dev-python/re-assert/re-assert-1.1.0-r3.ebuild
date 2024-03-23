# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Show where your regex match assertion failed"
HOMEPAGE="
	https://github.com/asottile/re-assert/
	https://pypi.org/project/re-assert/
"
SRC_URI="
	https://github.com/asottile/re-assert/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/regex[${PYTHON_USEDEP}]
	' 'python*')
"

distutils_enable_tests pytest

PATCHES=(
	# use `re` as fallback since `regex` doesn't support PyPy
	"${FILESDIR}/${P}-re-fallback.patch"
)

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local EPYTEST_DESELECT=()

	case ${EPYTHON} in
		pypy3)
			EPYTEST_DESELECT+=(
				# message/repr mismatches due to using `re` module
				tests/re_assert_test.py::test_fail_at_beginning
				tests/re_assert_test.py::test_fail_at_end_of_line
				tests/re_assert_test.py::test_fail_at_end_of_line_mismatching_newline
				tests/re_assert_test.py::test_fail_end_of_line_with_newline
				tests/re_assert_test.py::test_fail_multiple_lines
				tests/re_assert_test.py::test_match_with_tabs
				tests/re_assert_test.py::test_matches_repr_with_flags
				tests/re_assert_test.py::test_repr_with_failure
			)
			;;
	esac

	epytest
}

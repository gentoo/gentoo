# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 optfeature

DESCRIPTION="Python library for rendering rich text, tables, etc. to the terminal"
HOMEPAGE="
	https://github.com/Textualize/rich/
	https://pypi.org/project/rich/
"
SRC_URI="
	https://github.com/Textualize/rich/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/colorama[${PYTHON_USEDEP}]
	>=dev-python/markdown-it-py-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.13.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	local -x COLUMNS=80
	local EPYTEST_DESELECT=(
		# TODO
		tests/test_console.py::test_size_can_fall_back_to_std_descriptors
		tests/test_inspect.py::test_inspect_integer_with_methods_python38_and_python39
		# pygments?
		tests/test_syntax.py::test_python_render_simple_indent_guides
		tests/test_syntax.py::test_python_render_line_range_indent_guides
	)
	# version-specific output -- the usual deal
	case ${EPYTHON} in
		pypy3)
			EPYTEST_DESELECT+=(
				# pypy3.10, to be more precise
				tests/test_inspect.py::test_inspect_integer_with_methods_python310only
			)
			;;
		python3.12)
			EPYTEST_DESELECT+=(
				tests/test_inspect.py::test_inspect_builtin_function_except_python311
				tests/test_inspect.py::test_inspect_integer_with_methods_python310only
				tests/test_inspect.py::test_inspect_integer_with_methods_python311_and_above
				tests/test_pretty.py::test_attrs_broken
			)
			;;
	esac
	epytest -p no:pytest-qt
}

pkg_postinst() {
	optfeature "integration with HTML widgets for Jupyter" dev-python/ipywidgets
}

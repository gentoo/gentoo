# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

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
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	dev-python/colorama[${PYTHON_USEDEP}]
	>=dev-python/markdown-it-py-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.13.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/attrs-21.4.0[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	# https://github.com/Textualize/rich/pull/3622
	"${FILESDIR}"/${PN}-14.0.0-py314.patch
)

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# TODO
		tests/test_console.py::test_size_can_fall_back_to_std_descriptors
		# TODO: segfault in recursion (PyQt6 interfering?)
		tests/test_traceback.py::test_recursive
		# TODO: some random dep changes?
		tests/test_markdown.py::test_inline_code
		tests/test_syntax.py::test_blank_lines
		tests/test_syntax.py::test_python_render_simple_indent_guides
		# pygments version?
		tests/test_syntax.py::test_from_path
		tests/test_syntax.py::test_syntax_guess_lexer
	)
	# version-specific output -- the usual deal
	case ${EPYTHON} in
		pypy3)
			EPYTEST_DESELECT+=(
				# pypy3.10, to be more precise
				tests/test_inspect.py::test_inspect_integer_with_methods_python310only
			)
			;;
		pypy3.11)
			EPYTEST_DESELECT+=(
				tests/test_inspect.py::test_inspect_integer_with_methods_python311
			)
			;;
		python3.14*)
			EPYTEST_DESELECT+=(
				# Span vs Style
				tests/test_text.py::test_assemble_meta
			)
	esac

	local -x COLUMNS=80
	epytest
}

pkg_postinst() {
	optfeature "integration with HTML widgets for Jupyter" dev-python/ipywidgets
}

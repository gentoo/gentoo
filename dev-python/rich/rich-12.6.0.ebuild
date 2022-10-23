# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{8..11} pypy3 )

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
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/commonmark[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	' 3.8)
"

distutils_enable_tests pytest

python_test() {
	local -x COLUMNS=80
	local EPYTEST_DESELECT=(
		# broken with >=dev-python/pygments-2.12.0
		tests/test_console.py::test_size_can_fall_back_to_std_descriptors
		tests/test_inspect.py::test_inspect_integer_with_methods_python38_and_python39
	)
	[[ ${EPYTHON} == python3.11 ]] && EPYTEST_DESELECT+=(
		# the usual deal: output changes that cause test mismatches
		tests/test_inspect.py::test_inspect_text
		tests/test_inspect.py::test_inspect_builtin_function
		tests/test_inspect.py::test_inspect_integer_with_methods
		tests/test_log.py::test_log
		tests/test_pretty.py::test_attrs_broken
	)
	epytest -p no:pytest-qt
}

pkg_postinst() {
	optfeature "integration with HTML widgets for Jupyter" dev-python/ipywidgets
}

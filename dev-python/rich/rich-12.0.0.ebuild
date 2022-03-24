# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1 optfeature

DESCRIPTION="Python library for renrering rich text, tables, etc. to the terminal"
HOMEPAGE="https://github.com/Textualize/rich"
SRC_URI="
	https://github.com/Textualize/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/commonmark[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# check for exact color render string, which changes across pygments bumps
		tests/test_syntax.py::test_python_render
		tests/test_syntax.py::test_python_render_simple
		tests/test_syntax.py::test_python_render_indent_guides
	)
	epytest -p no:pytest-qt
}

pkg_postinst() {
	optfeature "integration with HTML widgets for Jupyter" dev-python/ipywidgets
}

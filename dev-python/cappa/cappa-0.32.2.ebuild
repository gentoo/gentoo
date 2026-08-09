# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/DanCardin/cappa
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Declarative CLI argument parser"
HOMEPAGE="
	https://github.com/DanCardin/cappa/
	https://pypi.org/project/cappa/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/rich-12.1.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.12.0[${PYTHON_USEDEP}]
	>=dev-python/type-lens-0.2.5[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/attrs-18.0[${PYTHON_USEDEP}]
		>=dev-python/docstring-parser-0.17[${PYTHON_USEDEP}]
		>=dev-python/msgspec-0.19.0[${PYTHON_USEDEP}]
		>=dev-python/pydantic-1.8.0[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# sphinx can't find extension prior to installing the package
		tests/test_e2e.py::test_docutils
		# TODO, test env problem
		tests/help/test_line_wrapping.py::test_line_wraps_correctly_with_terminal_escape_codes
	)

	local -x COLUMNS=80
	epytest tests
}

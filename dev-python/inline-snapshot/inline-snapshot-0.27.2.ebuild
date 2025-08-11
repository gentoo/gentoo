# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Create and update inline snapshots in your Python tests"
HOMEPAGE="
	https://15r10nk.github.io/inline-snapshot/
	https://github.com/15r10nk/inline-snapshot/
	https://pypi.org/project/inline-snapshot/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-python/asttokens-2.0.5[${PYTHON_USEDEP}]
	>=dev-python/executing-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/pytest-8.3.4[${PYTHON_USEDEP}]
	>=dev-python/rich-13.7.1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/attrs[${PYTHON_USEDEP}]
		>=dev-python/black-23.3.0[${PYTHON_USEDEP}]
		>=dev-python/dirty-equals-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-6.75.5[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/mypy[${PYTHON_USEDEP}]
		' 'python*')
		>=dev-python/pydantic-2[${PYTHON_USEDEP}]
		>=dev-python/pytest-freezer-0.4.8[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-3.14.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-subtests-0.11.0[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGIN_LOAD_VIA_ENV=1
EPYTEST_PLUGINS=( "${PN}" pytest-{freezer,mock,subtests,xdist} )
EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# requires pyright
		'tests/test_typing.py::test_typing_args[pyright]'
		'tests/test_typing.py::test_typing_call[pyright]'
		# TODO
		tests/test_formating.py::test_format_command_fail
	)

	local -x COLUMNS=80
	local -x PYTHONPATH=${S}/src
	epytest
}

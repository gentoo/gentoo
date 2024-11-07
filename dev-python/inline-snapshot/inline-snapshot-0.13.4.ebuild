# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Create and update inline snapshots in your Python tests"
HOMEPAGE="
	https://15r10nk.github.io/inline-snapshot/
	https://github.com/15r10nk/inline-snapshot/
	https://pypi.org/project/inline-snapshot/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/asttokens-2.0.5[${PYTHON_USEDEP}]
	>=dev-python/black-23.3.0[${PYTHON_USEDEP}]
	>=dev-python/click-8.1.4[${PYTHON_USEDEP}]
	>=dev-python/executing-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/rich-13.7.1[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/tomli-2.0.0[${PYTHON_USEDEP}]
	' 3.10)
"
BDEPEND="
	test? (
		>=dev-python/dirty-equals-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-6.75.5[${PYTHON_USEDEP}]
		dev-python/pydantic[${PYTHON_USEDEP}]
		>=dev-python/pytest-subtests-0.11.0[${PYTHON_USEDEP}]
		>=dev-python/time-machine-2.10.0[${PYTHON_USEDEP}]
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# requires pyright
		'tests/test_typing.py::test_typing[pyright]'
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=inline_snapshot.pytest_plugin,time_machine,pytest_subtests.plugin,xdist.plugin
	local -x PYTHONPATH=${S}/src
	epytest
}

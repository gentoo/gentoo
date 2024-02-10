# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Library for testing asyncio code with pytest"
HOMEPAGE="
	https://github.com/pytest-dev/pytest-asyncio/
	https://pypi.org/project/pytest-asyncio/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

RDEPEND="
	>=dev-python/pytest-5.4.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		>=dev-python/hypothesis-3.64[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# rely on precise warning counts
		tests/hypothesis/test_base.py::test_can_use_explicit_event_loop_fixture
		tests/modes/test_legacy_mode.py
		tests/modes/test_strict_mode.py::test_strict_mode_ignores_unmarked_fixture
		tests/test_event_loop_fixture_finalizer.py::test_event_loop_fixture_finalizer_raises_warning_when_fixture_leaves_loop_unclosed
		tests/test_event_loop_fixture_finalizer.py::test_event_loop_fixture_finalizer_raises_warning_when_test_leaves_loop_unclosed
		tests/test_pytest_min_version_warning.py
		tests/trio/test_fixtures.py::test_strict_mode_ignores_trio_fixtures
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=pytest_asyncio.plugin,_hypothesis_pytestplugin
	epytest
}

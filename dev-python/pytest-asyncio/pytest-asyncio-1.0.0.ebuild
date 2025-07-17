# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} python3_{13,14}t pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Library for testing asyncio code with pytest"
HOMEPAGE="
	https://github.com/pytest-dev/pytest-asyncio/
	https://pypi.org/project/pytest-asyncio/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

RDEPEND="
	>=dev-python/pytest-8.2[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( hypothesis )
EPYTEST_PLUGIN_LOAD_VIA_ENV=1
EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# fail due to mismatched warning count
		tests/test_event_loop_fixture.py::test_event_loop_already_closed
		tests/test_event_loop_fixture.py::test_event_loop_fixture_asyncgen_error
		tests/test_event_loop_fixture.py::test_event_loop_fixture_handles_unclosed_async_gen
		tests/modes/test_strict_mode.py::test_strict_mode_marked_test_unmarked_fixture_warning
		tests/modes/test_strict_mode.py::test_strict_mode_marked_test_unmarked_autouse_fixture_warning
		# TODO
		tests/modes/test_strict_mode.py::test_strict_mode_ignores_unmarked_coroutine
		tests/modes/test_strict_mode.py::test_strict_mode_ignores_unmarked_fixture
	)

	local EPYTEST_PLUGINS=( "${EPYTEST_PLUGINS[@]}" pytest-asyncio )
	epytest
}

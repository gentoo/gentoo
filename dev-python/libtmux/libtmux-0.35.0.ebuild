# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1

DESCRIPTION="Typed library that provides an ORM wrapper for tmux, a terminal multiplexer"
HOMEPAGE="
	https://libtmux.git-pull.com/
	https://github.com/tmux-python/libtmux/
	https://pypi.org/project/libtmux/
"
SRC_URI="
	https://github.com/tmux-python/libtmux/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

RDEPEND="
	>=app-misc/tmux-3.0a
"
BDEPEND="
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	local issues="https://github.com/tmux-python/libtmux/issues/"
	sed -r -i "s|:issue:\`([[:digit:]]+)\`|\`issue \1 ${issues}\1\`|" CHANGES || die

	# increase timeouts for tests
	sed -e 's/0.01/0.1/' -i tests/test_test.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	# tests/test_window.py::test_fresh_window_data fails if TMUX_PANE is set
	# https://bugs.gentoo.org/927158
	local -x TMUX_PANE=
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=libtmux.pytest_plugin

	local EPYTEST_DESELECT=(
		# flaky tests
		tests/legacy_api/test_test.py::test_function_times_out
		tests/legacy_api/test_test.py::test_function_times_out_no_raise
		tests/legacy_api/test_test.py::test_function_times_out_no_raise_assert
	)
	epytest -o addopts= -p pytest_mock -p rerunfailures tests
}

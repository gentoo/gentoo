# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/tmux-python/libtmux
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Typed library that provides an ORM wrapper for tmux, a terminal multiplexer"
HOMEPAGE="
	https://libtmux.git-pull.com/
	https://github.com/tmux-python/libtmux/
	https://pypi.org/project/libtmux/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

RDEPEND="
	>=app-misc/tmux-3.0a
"

EPYTEST_PLUGIN_LOAD_VIA_ENV=1
EPYTEST_PLUGINS=( "${PN}" pytest-mock )
EPYTEST_RERUNS=5
distutils_enable_tests pytest

python_test() {
	# tests/test_window.py::test_fresh_window_data fails if TMUX_PANE is set
	# https://bugs.gentoo.org/927158
	local -x TMUX_PANE=

	epytest -o addopts= tests
}

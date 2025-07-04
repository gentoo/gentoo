# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..13} pypy3 pypy3_11 )

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
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"

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

	distutils-r1_python_prepare_all
}

python_test() {
	# tests/test_window.py::test_fresh_window_data fails if TMUX_PANE is set
	# https://bugs.gentoo.org/927158
	local -x TMUX_PANE=
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=libtmux.pytest_plugin

	epytest -o addopts= -p pytest_mock -p rerunfailures --reruns=5 tests
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{9..12} pypy3 )

inherit distutils-r1

DESCRIPTION="Python API for tmux"
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
		dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	libtmux/pane.py::libtmux.pane.Pane.send_keys
	tests/legacy_api/test_test.py
)

python_prepare_all() {
	local issues="https://github.com/tmux-python/libtmux/issues/"
	sed -r -i "s|:issue:\`([[:digit:]]+)\`|\`issue \1 ${issues}\1\`|" CHANGES || die

	# increase timeouts for tests
	sed -e 's/0.01/0.1/' -i tests/test_test.py || die

	sed -r -e '/addopts/s:--doctest-docutils-modules::' \
		-e '/^[[:space:]]+"README\.md"/d' \
		-i pyproject.toml || die

	distutils-r1_python_prepare_all
}

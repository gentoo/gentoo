# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Dynamic version generation"
HOMEPAGE="
	https://github.com/mtkennerly/dunamai/
	https://pypi.org/project/dunamai/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-python/packaging-20.9[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-vcs/git
	)
"

EPYTEST_PLUGINS=()
EPYTEST_XDIST=1
distutils_enable_tests pytest

src_test() {
	local EPYTEST_DESELECT=(
		# Internet
		tests/integration/test_dunamai.py::test__version__from_git__shallow
	)

	git config --global user.email "you@example.com" || die
	git config --global user.name "Your Name" || die
	if type -P bzr &>/dev/null; then
		brz whoami "Your Name <name@example.com>" || die
	fi
	distutils-r1_src_test
}

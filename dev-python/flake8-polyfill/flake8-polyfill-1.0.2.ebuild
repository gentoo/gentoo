# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Polyfill package for Flake8 plugins"
HOMEPAGE="https://gitlab.com/pycqa/flake8-polyfill"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/flake8[${PYTHON_USEDEP}]"
BDEPEND="test? ( dev-python/mock[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# Get rid of the test that seems to test only the migration from
	# pep8 to pycodestyle (bug 598918).
	tests/test_stdin.py
)

src_prepare() {
	sed -e 's|\[pytest\]|\[tool:pytest\]|' -i setup.cfg || die
	distutils-r1_src_prepare
}

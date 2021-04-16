# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1 virtualx

COMMIT="4d0bf821abb193bfd158e2489970e1873a9f1138"

DESCRIPTION="Plugin for Spyder to enable Vim keybindings"
HOMEPAGE="https://github.com/spyder-ide/spyder-vim"
SRC_URI="https://github.com/spyder-ide/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">dev-python/spyder-4.0.0[${PYTHON_USEDEP}]"

DEPEND="test? (
	dev-python/flaky[${PYTHON_USEDEP}]
	dev-python/pytest-mock[${PYTHON_USEDEP}]
	dev-python/pytest-qt[${PYTHON_USEDEP}]
)"

DOCS=( "README.rst" "doc/example.gif" )

S="${WORKDIR}/${PN}-${COMMIT}"

distutils_enable_tests pytest

python_test() {
	virtx pytest -vv
}

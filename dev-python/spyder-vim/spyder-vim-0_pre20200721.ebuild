# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1 virtualx

COMMIT="c6f6ad75d1298d4cdadab69d57b2b4e2d235d8f3"

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

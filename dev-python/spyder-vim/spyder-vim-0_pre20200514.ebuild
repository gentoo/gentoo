# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_7 )

inherit distutils-r1 virtualx

COMMIT="0a5f982392a03a0f6448f2cfdfa116d027dc52b1"

DESCRIPTION="Plugin for Spyder to enable Vim keybindings"
HOMEPAGE="https://github.com/spyder-ide/spyder-vim"
SRC_URI="https://github.com/spyder-ide/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">dev-python/spyder-4.0.0[${PYTHON_USEDEP}]"

DEPEND="test? (
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/pytest-qt[${PYTHON_USEDEP}] )"

DOCS=( "README.rst" "doc/example.gif" )

S="${WORKDIR}/${PN}-${COMMIT}"

distutils_enable_tests pytest

python_test() {
	virtx pytest -vv
}

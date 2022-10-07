# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 virtualx

COMMIT="2ccf0d1e6ccaba24bd05b379065ba43bd935c7bf"

DESCRIPTION="Plugin for Spyder to enable Vim keybindings"
HOMEPAGE="https://github.com/spyder-ide/spyder-vim"
SRC_URI="https://github.com/spyder-ide/${PN}/archive/${COMMIT}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

RDEPEND="
	>=dev-python/spyder-5.3.3[${PYTHON_USEDEP}]
	<dev-python/spyder-6[${PYTHON_USEDEP}]
	"

DEPEND="test? (
	dev-python/flaky[${PYTHON_USEDEP}]
	dev-python/pytest-mock[${PYTHON_USEDEP}]
	dev-python/pytest-qt[${PYTHON_USEDEP}]
)"

DOCS=( "README.rst" "doc/example.gif" )

distutils_enable_tests pytest

python_test() {
	virtx epytest
}

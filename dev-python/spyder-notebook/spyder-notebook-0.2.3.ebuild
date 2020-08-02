# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_7 )

inherit distutils-r1 virtualx

DESCRIPTION="Jupyter notebook integration with Spyder"
HOMEPAGE="https://github.com/spyder-ide/spyder-notebook"
SRC_URI="https://github.com/spyder-ide/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/nbformat[${PYTHON_USEDEP}]
	dev-python/notebook[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	>=dev-python/spyder-4.0.0[${PYTHON_USEDEP}]"

DEPEND="test? (
	dev-python/flaky[${PYTHON_USEDEP}]
	dev-python/pytest-mock[${PYTHON_USEDEP}]
	dev-python/pytest-qt[${PYTHON_USEDEP}] )"

DOCS=( "README.md" "RELEASE.md" "CHANGELOG.md" "doc/example.gif" )

# Tests do not work inside virtx/emerge for some reason, core dumped
RESTRICT="test"
distutils_enable_tests pytest

pytthon_test() {
	virtx pytest -vv
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 virtualx

COMMIT="d210d9fe6c4efbb21d680a040cc4741d76a81f49"

DESCRIPTION="Plugin for Spyder to run tests and view the results"
HOMEPAGE="https://github.com/spyder-ide/spyder-unittest"
SRC_URI="https://github.com/spyder-ide/${PN}/archive/${COMMIT}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

# AttributeError: 'NoneType' object has no attribute 'split'
RESTRICT="test"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/spyder-5.3.1[${PYTHON_USEDEP}]
	<dev-python/spyder-6[${PYTHON_USEDEP}]
	dev-python/pyzmq[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
"

DEPEND="test? (
	dev-python/flaky[${PYTHON_USEDEP}]
	dev-python/nose[${PYTHON_USEDEP}]
	dev-python/pytest-mock[${PYTHON_USEDEP}]
	dev-python/pytest-qt[${PYTHON_USEDEP}]
)"

distutils_enable_tests pytest

python_test() {
	virtx epytest
}

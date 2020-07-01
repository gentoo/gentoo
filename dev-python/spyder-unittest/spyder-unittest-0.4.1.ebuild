# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_7 )

inherit distutils-r1 virtualx

DESCRIPTION="Plugin for Spyder to run tests and view the results"
HOMEPAGE="https://github.com/spyder-ide/spyder-unittest"
SRC_URI="https://github.com/spyder-ide/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-python/spyder-4.0.0[${PYTHON_USEDEP}]
	dev-python/pyzmq[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]"

DEPEND="test? (
	dev-python/flaky[${PYTHON_USEDEP}]
	dev-python/nose[${PYTHON_USEDEP}]
	dev-python/pytest-qt[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

python_test() {
	spyder_unittest_test() {
		# fails to test in ${BUILDIR}/lib
		# test do work if executed directly in the extracted tarball
		local PYTHONPATH="${WORKDIR}/${P}"
		pytest -vv spyder_unittest/tests spyder_unittest/widgets/tests
	}

	virtx spyder_unittest_test
}

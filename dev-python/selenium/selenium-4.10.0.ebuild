# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

# upstream sometimes tags it as ${P}, sometimes as ${P}-python, sigh
TEST_TAG=${P}
TEST_P=selenium-${TEST_TAG}

DESCRIPTION="Python language binding for Selenium Remote Control"
HOMEPAGE="
	https://www.seleniumhq.org/
	https://github.com/SeleniumHQ/selenium/tree/trunk/py/
	https://pypi.org/project/selenium/
"
SRC_URI+="
	test? (
		https://github.com/SeleniumHQ/selenium/archive/${TEST_TAG}.tar.gz
			-> ${TEST_P}.gh.tar.gz
	)
"

KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv ~s390 sparc x86"
LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
	>=dev-python/certifi-2021.10.8[${PYTHON_USEDEP}]
	<dev-python/trio-1[${PYTHON_USEDEP}]
	>=dev-python/trio-0.17[${PYTHON_USEDEP}]
	<dev-python/trio-websocket-1[${PYTHON_USEDEP}]
	>=dev-python/trio-websocket-0.9[${PYTHON_USEDEP}]
	<dev-python/urllib3-3[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.26[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# TODO: we may need extra setup or deps
		test/selenium

		# expects vanilla certifi
		test/unit/selenium/webdriver/remote/remote_connection_tests.py::test_get_connection_manager_for_certs_and_timeout
	)

	cd "${WORKDIR}/${TEST_P}/py" || die
	rm -rf selenium || die
	# https://github.com/SeleniumHQ/selenium/blob/selenium-4.8.2-python/py/test/runner/run_pytest.py#L20-L24
	# seriously?
	epytest -o "python_files=*_tests.py test_*.py"
}

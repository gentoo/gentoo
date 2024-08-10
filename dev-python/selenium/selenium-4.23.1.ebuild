# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_TESTED=( python3_{10..12} pypy3 )
PYTHON_COMPAT=( "${PYTHON_TESTED[@]}" python3_13 )

inherit distutils-r1 pypi

# upstream sometimes tags it as ${P}, sometimes as ${P}-python, sigh
TEST_TAG=${P}-python
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

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm arm64 ~loong ppc ~ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/certifi-2021.10.8[${PYTHON_USEDEP}]
	<dev-python/trio-1[${PYTHON_USEDEP}]
	>=dev-python/trio-0.17[${PYTHON_USEDEP}]
	<dev-python/trio-websocket-1[${PYTHON_USEDEP}]
	>=dev-python/trio-websocket-0.9[${PYTHON_USEDEP}]
	<dev-python/typing-extensions-5[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.9[${PYTHON_USEDEP}]
	<dev-python/urllib3-3[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.26[${PYTHON_USEDEP}]
	<dev-python/websocket-client-2[${PYTHON_USEDEP}]
	>=dev-python/websocket-client-1.8.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# do not build selenium-manager implicitly
	sed -e '/setuptools_rust/d' \
		-e '/rust_extensions/,/\]/d' \
		-i setup.py || die
}

python_test() {
	if ! has "${EPYTHON/./_}" "${PYTHON_TESTED[@]}"; then
		einfo "Skipping tests on ${EPYTHON}"
		return
	fi

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
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -o "python_files=*_tests.py test_*.py" -p pytest_mock
}

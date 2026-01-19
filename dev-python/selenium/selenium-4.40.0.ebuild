# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_TESTED=( python3_{11..14} pypy3_11 )
PYTHON_COMPAT=( "${PYTHON_TESTED[@]}" )

inherit distutils-r1 pypi

# base releases are usually ${P}, followups ${P}-python
TEST_TAG=${P}
[[ ${PV} != *.0 ]] && TEST_TAG+=-python
TEST_P=selenium-${TEST_TAG}

DESCRIPTION="Python language binding for Selenium Remote Control"
HOMEPAGE="
	https://seleniumhq.org/
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
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~x86"
IUSE="test test-rust"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/certifi-2026.1.4[${PYTHON_USEDEP}]
	>=dev-python/trio-0.31.0[${PYTHON_USEDEP}]
	>=dev-python/trio-websocket-0.12.2[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.15.0[${PYTHON_USEDEP}]
	>=dev-python/urllib3-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/websocket-client-1.8.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		$(python_gen_cond_dep "
			dev-python/filetype[\${PYTHON_USEDEP}]
			dev-python/pytest-mock[\${PYTHON_USEDEP}]
			test-rust? (
				dev-python/pytest[\${PYTHON_USEDEP}]
				dev-python/pytest-rerunfailures[\${PYTHON_USEDEP}]
				>=dev-util/selenium-manager-${PV}
				net-misc/geckodriver
				|| (
					www-client/firefox
					www-client/firefox-bin
				)
			)
		" "${PYTHON_TESTED[@]}")
	)
"

src_prepare() {
	distutils-r1_src_prepare

	# do not build selenium-manager implicitly
	sed -e 's:\[tool\.setuptools-rust:[tool.ignore-me:' \
		-i pyproject.toml || die
	# unpin deps
	sed -i -e 's:,<[0-9.]*::' pyproject.toml || die
	# remove nonsense typing deps
	sed -i -e '/types/d' -e '/typing/d' pyproject.toml || die
}

python_test() {
	# NB: xdist is causing random pytest crashes with high job numbers

	if ! has "${EPYTHON/./_}" "${PYTHON_TESTED[@]}"; then
		einfo "Skipping tests on ${EPYTHON}"
		return
	fi

	local EPYTEST_PLUGINS=( pytest-mock )
	local EPYTEST_IGNORE=()
	local EPYTEST_DESELECT=(
		# expects vanilla certifi
		test/unit/selenium/webdriver/remote/remote_connection_tests.py::test_get_connection_manager_for_certs_and_timeout
	)
	local pytest_args=(
		# https://github.com/SeleniumHQ/selenium/blob/selenium-4.8.2-python/py/test/runner/run_pytest.py#L20-L24
		# seriously?
		-o "python_files=*_tests.py test_*.py"
	)
	if use test-rust; then
		local -x PATH=${T}/bin:${PATH}
		local -x SE_MANAGER_PATH="$(type -P selenium-manager)"

		local EPYTEST_RERUNS=5
		pytest_args+=(
			--driver=firefox
			--browser-binary="$(type -P firefox || type -P firefox-bin)"
			--driver-binary="$(type -P geckodriver)"
			--headless
		)

		local EPYTEST_IGNORE+=(
			# requires some "python.runfiles", also bidi tests generally fail
			test/selenium/webdriver/common/bidi_webextension_tests.py
			# throws some error that pytest doesn't even show
			test/selenium/webdriver/firefox/ff_installs_addons_tests.py
		)
		EPYTEST_DESELECT+=(
			# expects prebuilt executables for various systems
			test/selenium/webdriver/common/selenium_manager_tests.py::test_uses_windows
			test/selenium/webdriver/common/selenium_manager_tests.py::test_uses_linux
			test/selenium/webdriver/common/selenium_manager_tests.py::test_uses_mac
			test/selenium/webdriver/common/selenium_manager_tests.py::test_errors_if_invalid_os

			# TODO: these don't respect --*-binary and try to fetch versions
			test/selenium/webdriver/firefox
			test/selenium/webdriver/marionette/mn_context_tests.py::test_context_sets_correct_context_and_returns
			test/selenium/webdriver/marionette/mn_context_tests.py::test_context_sets_correct_context_and_returns
			test/selenium/webdriver/marionette/mn_options_tests.py::TestIntegration::test_we_can_pass_options
			test/selenium/webdriver/marionette/mn_set_context_tests.py::test_we_can_switch_context_to_chrome

			# TODO
			'test/selenium/webdriver/common/devtools_tests.py::test_check_console_messages[firefox]'

			# TODO
			test/selenium/webdriver/common/bidi_browser_tests.py
			test/selenium/webdriver/common/bidi_browsing_context_tests.py
			test/selenium/webdriver/common/bidi_emulation_tests.py
			test/selenium/webdriver/common/bidi_input_tests.py
			test/selenium/webdriver/common/bidi_network_tests.py
			test/selenium/webdriver/common/bidi_permissions_tests.py
			test/selenium/webdriver/common/bidi_script_tests.py
			test/selenium/webdriver/common/bidi_session_tests.py
			test/selenium/webdriver/common/bidi_storage_tests.py
			test/selenium/webdriver/common/bidi_tests.py
			test/selenium/webdriver/marionette/mn_options_tests.py::TestUnit::test_binary
			test/selenium/webdriver/marionette/mn_options_tests.py::TestUnit::test_ctor
			test/selenium/webdriver/marionette/mn_options_tests.py::TestUnit::test_prefs
			test/selenium/webdriver/marionette/mn_options_tests.py::TestUnit::test_to_capabilities
			test/selenium/webdriver/remote/remote_custom_locator_tests.py::test_find_element_with_custom_locator
			test/selenium/webdriver/remote/remote_custom_locator_tests.py::test_find_elements_with_custom_locator

			# Internet
			test/selenium/webdriver/remote/remote_server_tests.py::test_download_latest_server
		)
	else
		EPYTEST_IGNORE+=(
			test/selenium
		)
	fi

	cd "${WORKDIR}/${TEST_P}/py" || die
	rm -rf selenium || die
	epytest "${pytest_args[@]}"
}

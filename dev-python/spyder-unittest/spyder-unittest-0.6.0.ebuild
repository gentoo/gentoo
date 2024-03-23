# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 virtualx

DESCRIPTION="Plugin for Spyder to run tests and view the results"
HOMEPAGE="https://github.com/spyder-ide/spyder-unittest"
SRC_URI="https://github.com/spyder-ide/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/spyder-5.4.1[${PYTHON_USEDEP}]
	<dev-python/spyder-6[${PYTHON_USEDEP}]
	dev-python/pyzmq[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
"

DEPEND="test? (
	dev-python/flaky[${PYTHON_USEDEP}]
	dev-python/pytest-mock[${PYTHON_USEDEP}]
	dev-python/pytest-qt[${PYTHON_USEDEP}]
)"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Hangs
	spyder_unittest/widgets/tests/test_datatree.py::test_contextMenuEvent_calls_exec
	# clicked() does not seem to work in emerge env
	spyder_unittest/widgets/tests/test_confpage.py::test_unittestconfigpage
	spyder_unittest/widgets/tests/test_unittestgui.py::test_unittestwidget_forwards_sig_edit_goto
	spyder_unittest/widgets/tests/test_unittestgui.py::test_unittestwidget_set_config_emits_newconfig
	spyder_unittest/widgets/tests/test_unittestgui.py::test_unittestwidget_set_config_does_not_emit_when_invalid
	spyder_unittest/widgets/tests/test_unittestgui.py::test_unittestwidget_config_with_unknown_framework_invalid
	spyder_unittest/widgets/tests/test_unittestgui.py::test_unittestwidget_process_finished_updates_results
	spyder_unittest/widgets/tests/test_unittestgui.py::test_unittestwidget_replace_pending_with_not_run
	spyder_unittest/widgets/tests/test_unittestgui.py::test_unittestwidget_tests_collected
	spyder_unittest/widgets/tests/test_unittestgui.py::test_unittestwidget_tests_started
	spyder_unittest/widgets/tests/test_unittestgui.py::test_unittestwidget_tests_collect_error
	spyder_unittest/widgets/tests/test_unittestgui.py::test_unittestwidget_tests_yield_results
	spyder_unittest/widgets/tests/test_unittestgui.py::test_unittestwidget_set_message
	spyder_unittest/widgets/tests/test_unittestgui.py::test_run_tests_starts_testrunner
	spyder_unittest/widgets/tests/test_unittestgui.py::test_run_tests_with_pre_test_hook_returning_true
	spyder_unittest/widgets/tests/test_unittestgui.py::test_run_tests_with_pre_test_hook_returning_false
	spyder_unittest/widgets/tests/test_unittestgui.py::test_unittestwidget_process_finished_updates_status_label
	spyder_unittest/widgets/tests/test_unittestgui.py::test_unittestwidget_process_finished_abnormally_status_label
	spyder_unittest/widgets/tests/test_unittestgui.py::test_unittestwidget_handles_sig_single_test_run_requested
	spyder_unittest/widgets/tests/test_unittestgui.py::test_run_tests_and_display_results
	spyder_unittest/widgets/tests/test_unittestgui.py::test_run_tests_using_unittest_and_display_results
	spyder_unittest/widgets/tests/test_unittestgui.py::test_run_tests_with_print_using_unittest_and_display_results
	spyder_unittest/widgets/tests/test_unittestgui.py::test_run_with_no_tests_discovered_and_display_results
	spyder_unittest/widgets/tests/test_unittestgui.py::test_stop_running_tests_before_testresult_is_received
	spyder_unittest/widgets/tests/test_unittestgui.py::test_show_versions
	spyder_unittest/widgets/tests/test_unittestgui.py::test_get_versions

	# Broken in Pyside2
	spyder_unittest/tests/test_unittestplugin.py::test_menu_item
	spyder_unittest/tests/test_unittestplugin.py::test_pythonpath_change
	spyder_unittest/tests/test_unittestplugin.py::test_default_working_dir
	spyder_unittest/tests/test_unittestplugin.py::test_plugin_config
	spyder_unittest/tests/test_unittestplugin.py::test_go_to_test_definition

	# Don't depend on nose2
	spyder_unittest/backend/workers/tests/test_print_versions.py::test_get_nose2_info
)

EPYTEST_IGNORE=(
	# Example test that somehow gets picked up
	doc/example/test_foo.py
)

python_test() {
	virtx epytest
}

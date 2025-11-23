# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/pytest-dev/pytest-qt
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 virtualx pypi

DESCRIPTION="Pytest plugin for PyQt6 and PySide6 applications"
HOMEPAGE="
	https://pypi.org/project/pytest-qt/
	https://github.com/pytest-dev/pytest-qt/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
	>=dev-python/pluggy-1.1[${PYTHON_USEDEP}]
	dev-python/qtpy[gui,testlib,widgets(+),${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		|| (
			dev-python/pyqt6[gui,testlib,widgets,${PYTHON_USEDEP}]
			dev-python/pyqt5[gui,testlib,widgets,${PYTHON_USEDEP}]
			dev-python/pyside:6[gui,testlib,widgets,${PYTHON_USEDEP}]
		)
	)
"

EPYTEST_PLUGIN_LOAD_VIA_ENV=1
EPYTEST_PLUGINS=( "${PN}" )
distutils_enable_tests pytest
distutils_enable_sphinx docs dev-python/sphinx-rtd-theme

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	local EPYTEST_DESELECT=(
		# requires the window to be activated; that doesn't seem
		# to be possible inside Xvfb
		"tests/test_basics.py::test_wait_window[waitActive-True]"

		# TODO
		tests/test_exceptions.py::test_exceptions_dont_leak

		# we are forcing a specific module via envvar, effectively
		# overriding the config
		tests/test_basics.py::test_qt_api_ini_config
		tests/test_basics.py::test_qt_api_ini_config_with_envvar
	)

	local -x QT_API PYTEST_QT_API
	local tests_ran=
	for QT_API in pyqt{5,6} "pyside:6"; do
		if has_version "dev-python/${QT_API}[gui,testlib,widgets,${PYTHON_USEDEP}]"
		then
			PYTEST_QT_API=${QT_API//:/}
			einfo "Testing with ${EPYTHON} and ${PYTEST_QT_API}"
			# force-disable xfail_strict as upstream as xfail assumptions
			# don't seem to hold on arm64
			nonfatal epytest -oxfail_strict=false ||
				die -n "Tests failed with ${EPYTHON} and ${PYTEST_QT_API}" ||
				return 1
			tests_ran=1
		fi
	done

	if [[ ! ${tests_ran} ]]; then
		die "No tests ran!"
	fi
}

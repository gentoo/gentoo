# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )
PYSIDE2_COMPAT=( python3_{10..11} )

inherit distutils-r1 virtualx pypi

DESCRIPTION="Pytest plugin for PyQt5 and PySide2 applications"
HOMEPAGE="
	https://pypi.org/project/pytest-qt/
	https://github.com/pytest-dev/pytest-qt/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="
	dev-python/QtPy[gui,testlib,widgets(+),${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		|| (
			dev-python/PyQt6[gui,testlib,widgets,${PYTHON_USEDEP}]
			dev-python/PyQt5[gui,testlib,widgets,${PYTHON_USEDEP}]
			dev-python/pyside6[gui,testlib,widgets,${PYTHON_USEDEP}]
			$(python_gen_cond_dep '
				dev-python/pyside2[gui,testlib,widgets,${PYTHON_USEDEP}]
			' "${PYSIDE2_COMPAT[@]}")
		)
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx docs dev-python/sphinx-rtd-theme

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	# warnings from other plugins cause the test output matchers to fail
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=pytestqt.plugin

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

	local -x PYTEST_QT_API
	for PYTEST_QT_API in PyQt{5,6} pyside{2,6}; do
		if has_version "dev-python/${PYTEST_QT_API}[gui,testlib,widgets,${PYTHON_USEDEP}]"
		then
			einfo "Testing with ${EPYTHON} and ${PYTEST_QT_API}"
			# force-disable xfail_strict as upstream as xfail assumptions
			# don't seem to hold on arm64
			nonfatal epytest -oxfail_strict=false ||
				die -n "Tests failed with ${EPYTHON} and ${PYTEST_QT_API}" ||
				return 1
		fi
	done
}

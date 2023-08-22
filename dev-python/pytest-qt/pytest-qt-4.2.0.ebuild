# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )
PYSIDE2_COMPAT=( python3_{10..11} )
PYSIDE6_COMPAT=( python3_{10..11} )

inherit distutils-r1 virtualx pypi

DESCRIPTION="Pytest plugin for PyQt5 and PySide2 applications"
HOMEPAGE="
	https://pypi.org/project/pytest-qt/
	https://github.com/pytest-dev/pytest-qt/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND="
	dev-python/QtPy[gui,testlib,widgets(+),${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/PyQt5[gui,testlib,widgets,${PYTHON_USEDEP}]
		amd64? (
			dev-python/PyQt6[gui,testlib,widgets,${PYTHON_USEDEP}]
		)
		$(python_gen_cond_dep '
			dev-python/pyside2[gui,testlib,widgets,${PYTHON_USEDEP}]
		' "${PYSIDE2_COMPAT[@]}")
		amd64? (
			$(python_gen_cond_dep '
				dev-python/pyside6[gui,testlib,widgets,${PYTHON_USEDEP}]
			' "${PYSIDE6_COMPAT[@]}")
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

		# we are forcing a specific module via envvar, effectively
		# overriding the config
		tests/test_basics.py::test_qt_api_ini_config
		tests/test_basics.py::test_qt_api_ini_config_with_envvar
	)

	einfo "Testing with PyQt5"
	PYTEST_QT_API="pyqt5" epytest || die
	if use amd64; then
		einfo "Testing with PyQt6"
		PYTEST_QT_API="pyqt6" epytest || die
	fi
	# Pyside{2,6} is not compatible with python3.12
	if has "${EPYTHON}" "${PYSIDE2_COMPAT[@]/_/.}"; then
		einfo "Testing with PySide2"
		PYTEST_QT_API="pyside2" epytest || die
	fi
	if use amd64 && has "${EPYTHON}" "${PYSIDE6_COMPAT[@]/_/.}"; then
		einfo "Testing with PySide6"
		PYTEST_QT_API="pyside6" epytest || die
	fi
}

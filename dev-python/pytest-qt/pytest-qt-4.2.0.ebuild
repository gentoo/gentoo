# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
PYSIDE2_COMPAT=( python3_{8..10} )

inherit distutils-r1 virtualx

DESCRIPTION="Pytest plugin for PyQt5 and PySide2 applications"
HOMEPAGE="
	https://pypi.org/project/pytest-qt/
	https://github.com/pytest-dev/pytest-qt/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND="
	dev-python/QtPy[gui,testlib,widgets(+),${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/PyQt5[gui,testlib,widgets,${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/pyside2[gui,testlib,widgets,${PYTHON_USEDEP}]
		' "${PYSIDE2_COMPAT[@]}")
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
	# Pyside2 is not compatible with python3.11
	if has "${EPYTHON}" "${PYSIDE2_COMPAT[@]/_/.}"; then
		einfo "Testing with PySide2"
		PYTEST_QT_API="pyside2" epytest || die
	fi
}

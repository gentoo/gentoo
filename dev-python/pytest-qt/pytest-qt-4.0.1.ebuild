# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 virtualx

DESCRIPTION="pytest plugin for PyQt5 and PySide2 applications"
HOMEPAGE="
	https://pypi.org/project/pytest-qt/
	https://github.com/pytest-dev/pytest-qt/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/QtPy[gui,testlib,widgets(+),${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/PyQt5[gui,testlib,widgets,${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/pyside2[gui,testlib,widgets,${PYTHON_USEDEP}]
			' python3_{8..9} )
	)
"

distutils_enable_tests --install pytest
distutils_enable_sphinx docs dev-python/sphinx_rtd_theme

python_prepare_all() {
	# This show window test does not work inside the emerge env, as we cannot show windows.
	# pytestqt.exceptions.TimeoutError: widget <PyQt5.QtWidgets.QWidget object at 0x7f57d8527af8> not activated in 1000 ms.
	sed -i -e 's:test_wait_window:_&:' tests/test_basics.py || die

	# This is not going to work since we want to test both implementations
	# and therefore pull in both and explicitly set PYTEST_QT_API
	sed -i -e 's:test_qt_api_ini_config_with_envvar:_&:' \
		-e 's:test_qt_api_ini_config:_&:' \
		tests/test_basics.py || die

	distutils-r1_python_prepare_all
}

src_test() {
	virtx python_foreach_impl python_test
}

python_test() {
	distutils_install_for_testing
	PYTEST_QT_API="pyqt5" epytest
	if [[ "${EPYTHON}" == "python3.10" ]]; then
		return
	else
		PYTEST_QT_API="pyside2" epytest
	fi
}

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1 virtualx

DESCRIPTION="pytest plugin for PyQt4 or PyQt5 applications"
HOMEPAGE="
	https://pypi.org/project/pytest-qt/
	https://github.com/pytest-dev/pytest-qt/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="dev-python/QtPy[gui,testlib,${PYTHON_USEDEP}]"

# Patch 1 skips a test that does not work inside the emerge environment:
# pytestqt.exceptions.TimeoutError: widget <PyQt5.QtWidgets.QWidget object at 0x7f57d8527af8> not activated in 1000 ms.
# Patch 2 fixes upstream bug 314
PATCHES=(
	"${FILESDIR}/${P}-skip-show-window-test.patch"
	"${FILESDIR}/${P}-fix-file-match-test.patch"
)

distutils_enable_tests pytest
distutils_enable_sphinx docs dev-python/sphinx_rtd_theme

python_test() {
	pytest_qt_test() {
		# pytest-qt test fail to test in ${BUILDIR}/lib
		# if and only if pytest-qt is not already installed
		# test do work if executed directly in the extracted tarball
		local PYTHONPATH="${WORKDIR}/${P}"
		pytest -vv
	}

	virtx pytest_qt_test
}

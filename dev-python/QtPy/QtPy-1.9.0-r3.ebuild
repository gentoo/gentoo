# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1 virtualx

DESCRIPTION="Abstraction layer on top of PyQt5 and PySide2 and additional custom QWidgets"
HOMEPAGE="https://github.com/spyder-ide/qtpy"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 x86"
IUSE="designer gui opengl printsupport svg testlib webengine"

# WARNING: the obvious solution of using || for PyQt5/pyside2 is not going
# to work.  The package only checks whether PyQt5/pyside2 is installed, it does
# not verify whether they have the necessary modules (i.e. satisfy the USE dep).
RDEPEND="
	dev-python/PyQt5[${PYTHON_USEDEP},designer?,opengl?,printsupport?,svg?]
	gui? ( dev-python/PyQt5[${PYTHON_USEDEP},gui,widgets] )
	testlib? ( dev-python/PyQt5[${PYTHON_USEDEP},testlib] )
	webengine? ( dev-python/PyQtWebEngine[${PYTHON_USEDEP}] )"
# The QtPy testsuite skips tests for bindings that are
# not installed, so here we ensure that everything
# is available and all tests are run.
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/PyQt5[${PYTHON_USEDEP}]
		dev-python/PyQt5[bluetooth,dbus,declarative,designer,gui,help,location]
		dev-python/PyQt5[multimedia,network,opengl,positioning,printsupport]
		dev-python/PyQt5[sensors,serialport,sql,svg,testlib,webchannel]
		dev-python/PyQt5[websockets,widgets,x11extras,xml(+),xmlpatterns]
		dev-python/PyQtWebEngine[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

src_prepare() {
	default

	sed -i -e "s/from PyQt4.Qt import/raise ImportError #/" qtpy/__init__.py || die
	sed -i -e "s/from PyQt4.QtCore import/raise ImportError #/" qtpy/__init__.py || die
	sed -i -e "s/from PySide import/raise ImportError #/" qtpy/__init__.py || die
	sed -i -e "s/from PySide2 import/raise ImportError #/" qtpy/__init__.py || die
}

python_test() {
	local -x QT_API="pyqt5"
	virtx pytest -vv
}

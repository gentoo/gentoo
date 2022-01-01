# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..8} )

inherit distutils-r1 virtualx

DESCRIPTION="Abstraction layer on top of PyQt5 and PySide2 and additional custom QWidgets"
HOMEPAGE="https://github.com/spyder-ide/qtpy/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

_IUSE_QT_MODULES="
	declarative designer gui help location multimedia network opengl
	positioning printsupport sensors serialport sql svg testlib webchannel
	webengine websockets widgets x11extras xml xmlpatterns
"
IUSE="+pyqt5 pyside2 ${_IUSE_QT_MODULES}"
unset _IUSE_QT_MODULES

REQUIRED_USE="
	|| ( pyqt5 pyside2 )
	test? ( pyqt5 pyside2 )
"

# These flags are currently *not* common to both the PySide2 and PyQt5 ebuild
# Disable them for now, please check periodically if this is still up to date.
# 	bluetooth? ( pyqt5 )
# 	dbus? ( pyqt5 )
# 	networkauth? ( pyqt5 )
# 	webkit? ( pyqt5 )
#
# 	3d? ( pyside2 )
# 	charts? ( pyside2 )
# 	concurrent? ( pyside2 )
# 	datavis? ( pyside2 )
# 	scxml? ( pyside2 )
# 	script? ( pyside2 )
# 	scripttools? ( pyside2 )
# 	speech? ( pyside2 )

# WARNING: the obvious solution of using || for PyQt5/pyside2 is not going
# to work.  The package only checks whether PyQt5/pyside2 is installed, it does
# not verify whether they have the necessary modules (i.e. satisfy the USE dep).
#
# Webengine is a special case, because PyQt5 provides this in a separate package
# while PySide2 ships it in the same package.
#
# declarative/qml/quick is a special case, because PyQt5 bundles the bindings
# for qml and quick in one flag: declarative PySide2 does not.
#
# The PyQt5 ebuild currently enables xml support unconditionally, the flag is
# added anyway with a (+) to make it future proof if the ebuild were to change
# this behaviour in the future.
#
# The PySide2 ebuild currently enables opengl and serialport support
# unconditionally, the flag is added anyway with a (+) to make it future proof
# if the ebuild were to change this behaviour in the future.
RDEPEND="
	pyqt5? (
		dev-python/PyQt5[${PYTHON_USEDEP}]
		dev-python/PyQt5[declarative?,designer?,gui?,help?,location?]
		dev-python/PyQt5[multimedia?,network?,opengl?,positioning?]
		dev-python/PyQt5[printsupport?,sensors?,serialport?,sql?,svg?]
		dev-python/PyQt5[testlib?,webchannel?,websockets?,widgets?]
		dev-python/PyQt5[x11extras?,xml(+)?,xmlpatterns?]
		webengine? ( dev-python/PyQtWebEngine[${PYTHON_USEDEP}] )
	)
	pyside2? (
		dev-python/pyside2[${PYTHON_USEDEP}]
		dev-python/pyside2[designer?,gui?,help?,location?,multimedia?]
		dev-python/pyside2[network?,opengl(+)?,positioning?,printsupport?]
		dev-python/pyside2[sensors?,serialport(+)?,sql?,svg?,testlib?]
		dev-python/pyside2[webchannel?,webengine?,websockets?,widgets?]
		dev-python/pyside2[x11extras?,xml?,xmlpatterns?]
		declarative? ( dev-python/pyside2[qml,quick] )
	)
"

# The QtPy testsuite skips tests for bindings that are not installed, so here we
# ensure that everything is available and all tests are run. Note that not
# all flags are available in PyQt5/PySide2, so some tests are still skipped.
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/PyQt5[${PYTHON_USEDEP}]
		dev-python/PyQt5[bluetooth,dbus,declarative,designer,gui,help,location]
		dev-python/PyQt5[multimedia,network,networkauth,opengl,positioning]
		dev-python/PyQt5[printsupport,sensors,serialport,sql,svg,testlib]
		dev-python/PyQt5[webchannel,websockets,widgets,x11extras,xml(+)]
		dev-python/PyQt5[xmlpatterns]
		dev-python/PyQtWebEngine[${PYTHON_USEDEP}]
		dev-python/pyside2[${PYTHON_USEDEP}]
		dev-python/pyside2[3d,charts,concurrent,datavis,designer,gui,help]
		dev-python/pyside2[location,multimedia,network,opengl(+),positioning]
		dev-python/pyside2[printsupport,qml,quick,script,scripttools,scxml]
		dev-python/pyside2[sensors,serialport(+),speech,sql,svg,testlib]
		dev-python/pyside2[webchannel,webengine,websockets,widgets,x11extras]
		dev-python/pyside2[xml,xmlpatterns]
)"

distutils_enable_tests pytest

src_prepare() {
	default
	if ! use pyqt5; then
		sed -i -e "s/from PyQt5.QtCore import/raise ImportError #/" qtpy/__init__.py || die
	fi
	if ! use pyside2; then
		sed -i -e "s/from PySide2 import/raise ImportError #/" qtpy/__init__.py || die
	fi

	# Disable outdated PyQt4 and PySide
	sed -i -e "s/from PyQt4.Qt import/raise ImportError #/" qtpy/__init__.py || die
	sed -i -e "s/from PyQt4.QtCore import/raise ImportError #/" qtpy/__init__.py || die
	sed -i -e "s/from PySide import/raise ImportError #/" qtpy/__init__.py || die
}

src_test() {
	virtx python_foreach_impl python_test
}

python_test() {
	local -x QT_API
	for QT_API in pyqt5 pyside2; do
		epytest
	done
}

pkg_postinst() {
	if use pyqt5 && use pyside2; then
		ewarn "You have enabled both PyQt5 and PySide2, note that QtPy will default"
		ewarn "to PyQt5 unless the QT_API environment variable overrides this."
	fi
}

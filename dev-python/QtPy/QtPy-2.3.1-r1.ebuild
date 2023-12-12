# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 virtualx pypi

DESCRIPTION="Abstraction layer on top of PyQt and PySide with additional custom QWidgets"
HOMEPAGE="
	https://github.com/spyder-ide/qtpy/
	https://pypi.org/project/QtPy/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"

_IUSE_QT_MODULES="
	designer +gui help multimedia +network opengl positioning
	printsupport qml quick serialport +sql svg testlib
	webchannel webengine websockets +widgets +xml
"
IUSE="+pyqt5 pyqt6 pyside2 pyside6 ${_IUSE_QT_MODULES}"
unset _IUSE_QT_MODULES

REQUIRED_USE="
	|| ( pyqt5 pyqt6 pyside2 pyside6 )
	python_targets_python3_12? ( !pyside2 !pyside6 )
"

# These flags are currently *not* common to the PySide2/6 and PyQt5/6 ebuilds
# Disable them for now, please check periodically if this is still up to date.
# 	bluetooth? ( pyqt5 only )
# 	dbus? ( pyqt5 only )
#
# 	3d? ( pyside2 only )
# 	charts? ( pyside2 only )
# 	concurrent? ( pyside2 only )
# 	datavis? ( pyside2 only )
# 	scxml? ( pyside2 only )
#
#	location? ( pyside2 and pyqt5 only )
#	sensors? ( pyside2 and pyqt5 only )
#	speech? ( pyside2 and pyqt5 only )
#	x11extras? ( pyside2 and pyqt5 only )
#	xmlpatterns? ( pyside2 and pyqt5 only )

# WARNING: the obvious solution of using || for PyQt5/pyside2 is not going
# to work. The package only checks whether PyQt5/pyside2 is installed, it does
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
	dev-python/packaging[${PYTHON_USEDEP}]
	pyqt5? (
		dev-python/PyQt5[${PYTHON_USEDEP}]
		dev-python/PyQt5[designer?,gui?,help?,multimedia?,network?,opengl?]
		dev-python/PyQt5[positioning?,printsupport?,serialport?,sql?,svg?]
		dev-python/PyQt5[testlib?,webchannel?,websockets?,widgets?,xml(+)?]
		qml? ( dev-python/PyQt5[declarative] )
		quick? ( dev-python/PyQt5[declarative] )
		webengine? ( dev-python/PyQtWebEngine[${PYTHON_USEDEP}] )
	)
	pyqt6? (
		dev-python/PyQt6[${PYTHON_USEDEP}]
		dev-python/PyQt6[designer?,gui?,help?,multimedia?,network?,opengl?]
		dev-python/PyQt6[positioning?,printsupport?,qml?,quick?,serialport?,sql?]
		dev-python/PyQt6[svg?,testlib?,webchannel?,websockets?,widgets?,xml?]
		webengine? ( dev-python/PyQt6-WebEngine[${PYTHON_USEDEP},widgets?,quick?] )

	)
	pyside2? (
		$(python_gen_cond_dep '
			dev-python/pyside2[${PYTHON_USEDEP}]
			dev-python/pyside2[designer?,gui?,help?,multimedia?,network?,opengl(+)?]
			dev-python/pyside2[positioning?,printsupport?,qml?,quick?,serialport(+)?]
			dev-python/pyside2[sql?,svg?,testlib?,webchannel?,webengine?,websockets?]
			dev-python/pyside2[widgets?,xml?]
		' python3_{10..11})
	)
	pyside6? (
		$(python_gen_cond_dep '
			dev-python/pyside6[${PYTHON_USEDEP}]
			dev-python/pyside6[designer?,gui?,help?,multimedia?,network?,opengl?]
			dev-python/pyside6[positioning?,printsupport?,qml?,quick?,serialport?]
			dev-python/pyside6[sql?,svg?,testlib?,webchannel?,webengine?,websockets?]
			dev-python/pyside6[widgets?,xml?]
		' python3_{10..11})
	)
"

# The QtPy testsuite skips tests for bindings that are not installed, so here we
# ensure that everything is available and all tests are run. Note that not
# all flags are available in PyQt5/PySide2, so some tests are still skipped.
BDEPEND="
	test? (
		pyqt5? (
			dev-python/PyQt5[${PYTHON_USEDEP}]
			dev-python/PyQt5[bluetooth,dbus,declarative,designer,gui,help,location]
			dev-python/PyQt5[multimedia,network,opengl,positioning,printsupport]
			dev-python/PyQt5[sensors,serialport,speech(-),sql,svg,testlib,webchannel]
			dev-python/PyQt5[websockets,widgets,x11extras,xml(+),xmlpatterns]
			dev-python/PyQtWebEngine[${PYTHON_USEDEP}]
		)
		pyqt6? (
			dev-python/PyQt6[${PYTHON_USEDEP}]
			dev-python/PyQt6[dbus,designer,gui,help,multimedia,network,opengl]
			dev-python/PyQt6[positioning,printsupport,qml,quick,quick3d,serialport]
			dev-python/PyQt6[sql,ssl,svg,testlib,webchannel,websockets,widgets,xml]
			dev-python/PyQt6-WebEngine[${PYTHON_USEDEP},widgets,quick]
		)
		pyside2? (
			$(python_gen_cond_dep '
				dev-python/pyside2[${PYTHON_USEDEP}]
				dev-python/pyside2[3d,charts,concurrent,datavis,designer,gui,help]
				dev-python/pyside2[location,multimedia,network,opengl(+),positioning]
				dev-python/pyside2[printsupport,qml,quick,scxml]
				dev-python/pyside2[sensors,serialport(+),speech,sql,svg,testlib]
				dev-python/pyside2[webchannel,webengine,websockets,widgets,x11extras]
				dev-python/pyside2[xml,xmlpatterns]
			' python3_{10..11})
		)
		pyside6? (
			$(python_gen_cond_dep '
				dev-python/pyside6[${PYTHON_USEDEP}]
				dev-python/pyside6[concurrent,dbus,designer,gui,help,multimedia]
				dev-python/pyside6[network,opengl,positioning,printsupport,qml]
				dev-python/pyside6[quick,quick3d,serialport,sql,svg,testlib]
				dev-python/pyside6[webchannel,webengine,websockets,widgets,xml]
			' python3_{10..11})
		)
	)
"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare
	sed -i -e 's:--cov=qtpy --cov-report=term-missing::' pytest.ini || die
	# Disable Qt for Python implementations that are not selected
	if ! use pyqt5; then
		sed -i -e "s/from PyQt5.QtCore import/raise ImportError #/" qtpy/__init__.py || die
	fi
	if ! use pyqt6; then
		sed -i -e "s/from PyQt6.QtCore import/raise ImportError #/" qtpy/__init__.py || die
	fi
	if ! use pyside2; then
		sed -i -e "s/from PySide2 import/raise ImportError #/" qtpy/__init__.py || die
		sed -i -e "s/from PySide2.QtCore import/raise ImportError #/" qtpy/__init__.py || die
	fi
	if ! use pyside6; then
		sed -i -e "s/from PySide6 import/raise ImportError #/" qtpy/__init__.py || die
		sed -i -e "s/from PySide6.QtCore import/raise ImportError #/" qtpy/__init__.py || die
	fi
}

python_test() {
	# Test for each enabled Qt4Python target.
	# Deselect the other targets, their test fails if we specify QT_API
	# or if we have disabled their corresponding inherit in __init__.py above
	if use pyqt5; then
		einfo "Testing with ${EPYTHON} and QT_API=PyQt5"
		QT_API="pyqt5" virtx epytest \
			--deselect qtpy/tests/test_main.py::test_qt_api_environ[PySide2] \
			--deselect qtpy/tests/test_main.py::test_qt_api_environ[PyQt6] \
			--deselect qtpy/tests/test_main.py::test_qt_api_environ[PySide6]
	fi
	if use pyqt6; then
		einfo "Testing with ${EPYTHON} and QT_API=PyQt6"
		QT_API="pyqt6" virtx epytest \
			--deselect qtpy/tests/test_main.py::test_qt_api_environ[PySide2] \
			--deselect qtpy/tests/test_main.py::test_qt_api_environ[PyQt5] \
			--deselect qtpy/tests/test_main.py::test_qt_api_environ[PySide6] \
			--deselect qtpy/tests/test_qtsensors.py::test_qtsensors
			# Qt6Sensors not yet packaged and enabled in PyQt6 ebuild
	fi
	if use pyside2; then
		einfo "Testing with ${EPYTHON} and QT_API=PySide2"
		QT_API="pyside2" virtx epytest \
			--deselect qtpy/tests/test_main.py::test_qt_api_environ[PyQt5] \
			--deselect qtpy/tests/test_main.py::test_qt_api_environ[PyQt6] \
			--deselect qtpy/tests/test_main.py::test_qt_api_environ[PySide6]
	fi
	if use pyside6; then
		einfo "Testing with ${EPYTHON} and QT_API=PySide6"
		QT_API="pyside6" virtx epytest \
			--deselect qtpy/tests/test_main.py::test_qt_api_environ[PySide2] \
			--deselect qtpy/tests/test_main.py::test_qt_api_environ[PyQt5] \
			--deselect qtpy/tests/test_main.py::test_qt_api_environ[PyQt6] \
			--deselect qtpy/tests/test_qtsensors.py::test_qtsensors
			# Qt6Sensors not yet packaged and enabled in PySide6 ebuild
	fi
}

pkg_postinst() {
	elog "When multiple Qt4Python targets are enabled QtPy will default to"
	elog "the first enabled target in this order: PyQt5 PySide2 PyQt6 PySide6."
	elog "This can be overridden with the QT_API environment variable."
}

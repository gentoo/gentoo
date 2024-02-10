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
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"

_IUSE_QT_MODULES="
	designer +gui help multimedia +network opengl positioning
	printsupport qml quick sensors serialport speech +sql svg testlib
	webchannel webengine websockets +widgets +xml
"
IUSE="+pyqt5 pyqt6 pyside2 pyside6 ${_IUSE_QT_MODULES}"
unset _IUSE_QT_MODULES

REQUIRED_USE="
	|| ( pyqt5 pyqt6 pyside2 pyside6 )
	python_targets_python3_12? ( !pyside2 )
"

# These flags are currently *not* common to the PySide2/6 and PyQt5/6 ebuilds
# Disable them for now, please check periodically if this is still up to date.
# 	bluetooth? ( pyqt5/6 and pyside6 only )
# 	dbus? ( pyqt5/6 and pyside6 only )
#
# 	3d? ( pyside2/6 only )
# 	charts? ( pyside2 only )
# 	concurrent? ( pyside2 only )
# 	datavis? ( pyside2 only )
# 	scxml? ( pyside2/6 only )
#
#	x11extras? ( pyside2 and pyqt5 only )
#	xmlpatterns? ( pyside2 and pyqt5 only )
#
# location? ( pyside2/6 and pyqt5 only)
# nfc? ( pyqt6 and pyside6 only)
# spatialaudio? ( pyqt6 and pyside6 only)
# pdfium? ( pyqt6 and pyside6 only)

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
		dev-python/PyQt5[positioning?,printsupport?,sensors?,serialport?,speech?,sql?,svg?]
		dev-python/PyQt5[testlib?,webchannel?,websockets?,widgets?,xml(+)?]
		qml? ( dev-python/PyQt5[declarative] )
		quick? ( dev-python/PyQt5[declarative] )
		webengine? ( dev-python/PyQtWebEngine[${PYTHON_USEDEP}] )
	)
	pyqt6? (
		dev-python/PyQt6[${PYTHON_USEDEP}]
		dev-python/PyQt6[designer?,gui?,help?,multimedia?,network?,opengl?]
		dev-python/PyQt6[positioning?,printsupport?,qml?,quick?,sensors?,serialport?,sql?]
		dev-python/PyQt6[speech?,svg?,testlib?,webchannel?,websockets?,widgets?,xml?]
		webengine? ( dev-python/PyQt6-WebEngine[${PYTHON_USEDEP},widgets?,quick?] )

	)
	pyside2? (
		$(python_gen_cond_dep '
			dev-python/pyside2[${PYTHON_USEDEP}]
			dev-python/pyside2[designer?,gui?,help?,multimedia?,network?,opengl(+)?]
			dev-python/pyside2[positioning?,printsupport?,qml?,quick?,sensors?,serialport(+)?]
			dev-python/pyside2[speech?,sql?,svg?,testlib?,webchannel?,webengine?,websockets?]
			dev-python/pyside2[widgets?,xml?]
		' python3_{10..11})
	)
	pyside6? (
		dev-python/pyside6[${PYTHON_USEDEP}]
		dev-python/pyside6[designer?,gui?,help?,multimedia?,network?,opengl?]
		dev-python/pyside6[positioning?,printsupport?,qml?,quick?,sensors(-)?,serialport?]
		dev-python/pyside6[speech(-)?,sql?,svg?,testlib?,webchannel?,webengine?,websockets?]
		dev-python/pyside6[widgets?,xml?]
	)
"

# The QtPy testsuite skips tests for bindings that are not installed, so here we
# ensure that everything is available and all tests are run. Note that not
# all flags are available in PyQt5/PySide2, so some tests are still skipped.
BDEPEND="
	test? (
		dev-python/pytest-qt[${PYTHON_USEDEP}]
		pyqt5? (
			dev-python/PyQt5[${PYTHON_USEDEP}]
			dev-python/PyQt5[bluetooth,dbus,declarative,designer,gui,help,location]
			dev-python/PyQt5[multimedia,network,opengl,positioning,printsupport]
			dev-python/PyQt5[sensors,serialport,speech(-),sql,svg,testlib,webchannel]
			dev-python/PyQt5[websockets,widgets,x11extras,xml(+),xmlpatterns]
			dev-python/PyQtWebEngine[${PYTHON_USEDEP}]
			dev-qt/qtsql:5[sqlite]
		)
		pyqt6? (
			dev-python/PyQt6[${PYTHON_USEDEP}]
			dev-python/PyQt6[dbus,designer,gui,help,multimedia,network,nfc,opengl]
			dev-python/PyQt6[pdfium(-),positioning,printsupport,qml,quick,quick3d,serialport]
			dev-python/PyQt6[sensors(-),spatialaudio(-),speech(-),sql,ssl,svg,testlib,webchannel]
			dev-python/PyQt6[websockets,widgets,xml]
			dev-python/PyQt6-WebEngine[${PYTHON_USEDEP},widgets,quick]
			dev-qt/qtbase:6[sqlite]
		)
		pyside2? (
			$(python_gen_cond_dep '
				dev-python/pyside2[${PYTHON_USEDEP}]
				dev-python/pyside2[3d,charts,concurrent,datavis,designer,gui,help]
				dev-python/pyside2[location,multimedia,network,opengl(+)]
				dev-python/pyside2[positioning,printsupport,qml,quick,scxml]
				dev-python/pyside2[sensors,serialport(+),speech,sql,svg,testlib]
				dev-python/pyside2[webchannel,webengine,websockets,widgets,x11extras]
				dev-python/pyside2[xml,xmlpatterns]
				dev-qt/qtsql:5[sqlite]
			' python3_{10..11})
		)
		pyside6? (
			dev-python/pyside6[${PYTHON_USEDEP}]
			dev-python/pyside6[3d(-),bluetooth(-),concurrent,dbus,designer,gui,help]
			dev-python/pyside6[location(-),multimedia,network,nfc(-),opengl,positioning,pdfium(-)]
			dev-python/pyside6[printsupport,qml,quick,quick3d,scxml(-),sensors(-)]
			dev-python/pyside6[serialport,spatialaudio(-),speech(-),sql,svg,testlib,webchannel]
			dev-python/pyside6[webengine,websockets,widgets,xml]
			dev-qt/qtbase:6[sqlite]
		)
	)
"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare
	sed -i -e 's:--cov=qtpy --cov-report=term-missing::' pytest.ini || die
	# Disable Qt for Python implementations that are not selected
	if ! use pyqt5; then
		sed \
			-e '/from PyQt5.QtCore import/,/)/c\ \ \ \ \ \ \ \ raise ImportError #/' \
			-e '/if "PyQt5" in sys.modules:/,/"pyqt5"/c\' \
			-i qtpy/__init__.py || die

		# We need to ensure the first option is an 'if' not 'elif'
		sed -e 's/elif "PySide2" in sys.modules:/if "PySide2" in sys.modules:/g' -i qtpy/__init__.py || die
	fi
	if ! use pyside2; then
		sed \
			-e "s/from PySide2 import/raise ImportError #/" \
			-e "s/from PySide2.QtCore import/raise ImportError #/" \
			-e '/if "PySide2" in sys.modules:/,/"pyside2"/c\' \
			-i qtpy/__init__.py || die

		if ! use pyqt5; then
			sed \
				-e 's/elif "PyQt6" in sys.modules:/if "PyQt6" in sys.modules:/g' \
				-i qtpy/__init__.py || die
		fi
	fi
	if ! use pyqt6; then
		sed \
			-e '/from PyQt6.QtCore import/,/)/c\ \ \ \ \ \ \ \ raise ImportError #/' \
			-e '/if "PyQt6" in sys.modules:/,/"pyqt6"/c\' \
			-i qtpy/__init__.py || die

		if ! use pyqt5 && ! use pyside2; then
			sed \
				-e 's/elif "PySide6" in sys.modules:/if "PySide6" in sys.modules:/g' \
				-i qtpy/__init__.py || die
		fi
	fi
	if ! use pyside6; then
		sed \
			-e "s/from PySide6 import/raise ImportError #/" \
			-e "s/from PySide6.QtCore import/raise ImportError #/" \
			-e '/if "PySide6" in sys.modules:/,/"pyside6"/c\' \
			-i qtpy/__init__.py || die
	fi
}

python_test() {
	local -x QT_API
	local -a EPYTEST_DESELECT
	local other

	# Test for each enabled Qt4Python target.
	# Deselect the other targets, their test fails if we specify QT_API
	# or if we have disabled their corresponding inherit in __init__.py above
	for QT_API in PyQt{5,6} PySide{2,6}; do
		if use "${QT_API,,}"; then
			EPYTEST_DESELECT=()
			for other in PyQt{5,6} PySide{2,6}; do
				if [[ ${QT_API} != ${other} ]]; then
					EPYTEST_DESELECT+=(
						"qtpy/tests/test_main.py::test_qt_api_environ[${other}]"
					)
				fi
			done

			einfo "Testing with ${EPYTHON} and QT_API=${QT_API}"
			nonfatal epytest ||
				die -n "Tests failed with ${EPYTHON} and QT_API=${QT_API}" ||
				return 1
		fi
	done
}

src_test() {
	virtx distutils-r1_src_test
}

pkg_postinst() {
	elog "When multiple Qt4Python targets are enabled QtPy will default to"
	elog "the first enabled target in this order: PyQt5 PySide2 PyQt6 PySide6."
	elog "This can be overridden with the QT_API environment variable."
}

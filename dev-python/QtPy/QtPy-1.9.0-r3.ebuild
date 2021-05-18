# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..8} )

inherit distutils-r1 virtualx

DESCRIPTION="Abstraction layer on top of PyQt5 and PySide2 and additional custom QWidgets"
HOMEPAGE="https://github.com/spyder-ide/qtpy"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

IUSE="
	declarative designer gui help location multimedia network
	opengl positioning printsupport qml quick sensors serialport
	sql svg test testlib webchannel webengine websockets
	widgets x11extras xml xmlpatterns
"

# Webengine is a special case, because PyQt5 provides this in a
# separate package , while PySide2 ships it in the same package
#
# declarative/qml/quick is a special case, because PyQt5 bundles
# the bindings for qml and quick in one flag: declarative,
# PySide2 does not.
#
# The PyQt5 ebuild currently enables xml support unconditionally,
# the flag is added anyway with a (+) to make it future proof
# if the ebuild were to change this behaviour in the future.
#
# The PySide2 ebuild currently enables opengl and serialport
# support unconditionally, the flag is added anyway with a (+)
# to make it future proof if the ebuild were to change this
# behaviour in the future.
#
RDEPEND="
	app-eselect/eselect-QtPy
	|| (
		dev-python/PyQt5[${PYTHON_USEDEP},designer?,gui?,help?,location?,multimedia?,network?,opengl?,positioning?,printsupport?,sensors?,serialport?,sql?,svg?,testlib?,webchannel?,websockets?,widgets?,x11extras?,xml(+)?,xmlpatterns?]
		dev-python/pyside2[${PYTHON_USEDEP},designer?,gui?,help?,location?,multimedia?,network?,opengl(+)?,positioning?,printsupport?,sensors?,serialport(+)?,sql?,svg?,testlib?,webchannel?,websockets?,widgets?,x11extras?,xml?,xmlpatterns?]
	)

	webengine? ( || (
		dev-python/PyQtWebEngine[${PYTHON_USEDEP}]
		dev-python/pyside2[${PYTHON_USEDEP},webengine]
	) )

	qml? ( || (
		dev-python/PyQt5[${PYTHON_USEDEP},declarative]
		dev-python/pyside2[${PYTHON_USEDEP},qml]
	) )

	quick? ( || (
		dev-python/PyQt5[${PYTHON_USEDEP},declarative]
		dev-python/pyside2[${PYTHON_USEDEP},quick]
	) )

	declarative? ( || (
		dev-python/PyQt5[${PYTHON_USEDEP},declarative]
		dev-python/pyside2[${PYTHON_USEDEP},qml,quick]
	) )
"

# These bindings are currently only provided by PyQt5 or PySide2
# but not by both. Just DEPEND on these directly if they are
# required.
# Please check periodically if this list is still up to date
#
# 	bluetooth? ( dev-python/PyQt5[${PYTHON_USEDEP},bluetooth] )
# 	dbus? ( dev-python/PyQt5[${PYTHON_USEDEP},dbus] )
# 	examples? ( dev-python/PyQt5[${PYTHON_USEDEP},examples] )
# 	networkauth? ( dev-python/PyQt5[${PYTHON_USEDEP},networkauth] )
# 	ssl? ( dev-python/PyQt5[${PYTHON_USEDEP},ssl] )
# 	webkit? ( dev-python/PyQt5[${PYTHON_USEDEP},webkit] )
#
# 	3d? ( dev-python/pyside2[${PYTHON_USEDEP},3d] )
# 	charts? ( dev-python/pyside2[${PYTHON_USEDEP},charts] )
# 	concurrent? ( dev-python/pyside2[${PYTHON_USEDEP},concurrent] )
# 	datavis? ( dev-python/pyside2[${PYTHON_USEDEP},datavis] )
# 	scxml? ( dev-python/pyside2[${PYTHON_USEDEP},scxml] )
# 	script? ( dev-python/pyside2[${PYTHON_USEDEP},script] )
# 	scripttools? ( dev-python/pyside2[${PYTHON_USEDEP},scripttools] )
# 	speech? ( dev-python/pyside2[${PYTHON_USEDEP},speech] )

# The QtPy testsuite skips tests for bindings that are
# not installed, so here we ensure that everything
# is available and all tests are run.
BDEPEND="test? (
	dev-python/PyQt5[${PYTHON_USEDEP},bluetooth,dbus,declarative,designer,gui,help,location,multimedia,network,networkauth,opengl,positioning,printsupport,sensors,serialport,sql,ssl,svg,testlib,webchannel,webkit,websockets,widgets,x11extras,xml(+),xmlpatterns]
	dev-python/PyQtWebEngine[${PYTHON_USEDEP}]
	dev-python/pyside2[${PYTHON_USEDEP},3d,charts,concurrent,datavis,designer,gui,help,location,multimedia,network,opengl(+),positioning,printsupport,qml,quick,script,scripttools,scxml,sensors,serialport(+),speech,sql,svg,testlib,webchannel,webengine,websockets,widgets,x11extras,xml,xmlpatterns]
)"

distutils_enable_tests pytest

python_test() {
	export QT_API="pyqt5"
	virtx pytest -vv
	export QT_API="pyside2"
	virtx pytest -vv
	unset QT_API
}

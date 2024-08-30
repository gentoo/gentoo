# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=sip
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1 flag-o-matic multiprocessing pypi qmake-utils

DESCRIPTION="Python bindings for the Qt framework"
HOMEPAGE="https://www.riverbankcomputing.com/software/pyqt/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~ppc ppc64 ~riscv x86"

IUSE="
	bluetooth dbus debug declarative designer examples gles2-only gui help location
	multimedia network opengl positioning printsupport sensors serialport speech
	sql +ssl svg testlib webchannel websockets widgets x11extras xmlpatterns
"

# The requirements below were extracted from the qmake_QT declarations
# in project.py and from the output of 'grep -r "%Import " ${S}/sip'
REQUIRED_USE="
	bluetooth? ( gui )
	declarative? ( gui network )
	designer? ( widgets )
	help? ( gui widgets )
	location? ( positioning )
	multimedia? ( gui network )
	opengl? ( gui widgets )
	positioning? ( gui )
	printsupport? ( gui widgets )
	sensors? ( gui )
	serialport? ( gui )
	sql? ( widgets )
	svg? ( gui widgets )
	testlib? ( widgets )
	webchannel? ( network )
	websockets? ( network )
	widgets? ( gui )
	xmlpatterns? ( network )
"

# Minimal supported version of Qt.
QT_PV="5.15:5"

DEPEND="
	>=dev-qt/qtcore-${QT_PV}
	>=dev-qt/qtxml-${QT_PV}
	bluetooth? ( >=dev-qt/qtbluetooth-${QT_PV} )
	dbus? (
		dev-python/dbus-python[${PYTHON_USEDEP}]
		>=dev-qt/qtdbus-${QT_PV}
		sys-apps/dbus
	)
	declarative? ( >=dev-qt/qtdeclarative-${QT_PV}[widgets?] )
	designer? ( >=dev-qt/designer-${QT_PV} )
	gui? ( >=dev-qt/qtgui-${QT_PV}[gles2-only=] )
	help? ( >=dev-qt/qthelp-${QT_PV} )
	location? ( >=dev-qt/qtlocation-${QT_PV} )
	multimedia? ( >=dev-qt/qtmultimedia-${QT_PV}[widgets?] )
	network? ( >=dev-qt/qtnetwork-${QT_PV}[ssl=] )
	opengl? ( >=dev-qt/qtopengl-${QT_PV} )
	positioning? ( >=dev-qt/qtpositioning-${QT_PV} )
	printsupport? ( >=dev-qt/qtprintsupport-${QT_PV} )
	sensors? ( >=dev-qt/qtsensors-${QT_PV} )
	serialport? ( >=dev-qt/qtserialport-${QT_PV} )
	speech? ( >=dev-qt/qtspeech-${QT_PV} )
	sql? ( >=dev-qt/qtsql-${QT_PV} )
	svg? ( >=dev-qt/qtsvg-${QT_PV} )
	testlib? ( >=dev-qt/qttest-${QT_PV} )
	webchannel? ( >=dev-qt/qtwebchannel-${QT_PV} )
	websockets? ( >=dev-qt/qtwebsockets-${QT_PV} )
	widgets? ( >=dev-qt/qtwidgets-${QT_PV} )
	x11extras? ( >=dev-qt/qtx11extras-${QT_PV} )
	xmlpatterns? ( >=dev-qt/qtxmlpatterns-${QT_PV} )
"
RDEPEND="
	${DEPEND}
	>=dev-python/PyQt5-sip-12.15:=[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/PyQt-builder-1.14.1[${PYTHON_USEDEP}]
	>=dev-python/sip-6.8.6[${PYTHON_USEDEP}]
	>=dev-qt/qtcore-${QT_PV}
	dbus? ( virtual/pkgconfig )
"

src_prepare() {
	default

	# hack: PyQt-builder runs qmake without our arguments and calls g++
	# or clang++ depending on what qtbase was built with, not used for
	# building but fails with -native-symlinks
	mkdir "${T}"/cxx || die
	local cxx
	! cxx=$(type -P "${CHOST}"-g++) || ln -s -- "${cxx}" "${T}"/cxx/g++ || die
	! cxx=$(type -P "${CHOST}"-clang++) || ln -s -- "${cxx}" "${T}"/cxx/clang++ || die
	PATH=${T}/cxx:${PATH}
}

python_configure_all() {
	append-cxxflags ${CPPFLAGS} # respect CPPFLAGS notably for DISTUTILS_EXT=1

	pyqt_use_enable() {
		local state=$(usex ${1} --enable= --disable=)
		shift
		echo ${*/#/${state}}
	}

	DISTUTILS_ARGS=(
		--jobs="$(makeopts_jobs)"
		--qmake="$(qt5_get_bindir)"/qmake
		--qmake-setting="$(qt5_get_qmake_args)"
		--verbose
		--confirm-license

		--enable=pylupdate
		--enable=pyrcc
		--enable=Qt
		--enable=QtCore
		$(pyqt_use_enable bluetooth QtBluetooth)
		$(pyqt_use_enable dbus QtDBus)
		$(pyqt_use_enable declarative QtQml QtQuick \
			$(usev widgets QtQuickWidgets))
		$(pyqt_use_enable designer QtDesigner)
		$(pyqt_use_enable gui QtGui \
			$(use gles2-only && echo _QOpenGLFunctions_ES2 || echo _QOpenGLFunctions_{2_0,2_1,4_1_Core}))
		$(pyqt_use_enable help QtHelp)
		$(pyqt_use_enable location QtLocation)
		$(pyqt_use_enable multimedia QtMultimedia \
			$(usev widgets QtMultimediaWidgets))
		$(pyqt_use_enable network QtNetwork)
		$(pyqt_use_enable opengl QtOpenGL)
		$(pyqt_use_enable positioning QtPositioning)
		$(pyqt_use_enable printsupport QtPrintSupport)
		$(pyqt_use_enable sensors QtSensors)
		$(pyqt_use_enable serialport QtSerialPort)
		$(pyqt_use_enable speech QtTextToSpeech)
		$(pyqt_use_enable sql QtSql)
		$(pyqt_use_enable svg QtSvg)
		$(pyqt_use_enable testlib QtTest)
		$(pyqt_use_enable webchannel QtWebChannel)
		$(pyqt_use_enable websockets QtWebSockets)
		$(pyqt_use_enable widgets QtWidgets)
		$(pyqt_use_enable x11extras QtX11Extras)
		--enable=QtXml
		$(pyqt_use_enable xmlpatterns QtXmlPatterns)

		$(usev debug '--debug --qml-debug --tracing')

		$(usev !dbus --no-dbus-python)
		# note: upstream currently intentionally skips installing these two
		# plugins when using wheels w/ pep517 so, *if* something does need
		# them, it will need to be handled manually
		$(usev !declarative --no-qml-plugin)
		$(usev !designer --no-designer-plugin)

		$(usev gles2-only --disabled-feature=PyQt_Desktop_OpenGL)
		$(usev !ssl --disabled-feature=PyQt_SSL)
	)
}

python_install_all() {
	einstalldocs
	use examples && dodoc -r examples
}

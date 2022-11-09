# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit python-r1 qmake-utils

DESCRIPTION="Python bindings for the Qt framework"
HOMEPAGE="https://www.riverbankcomputing.com/software/pyqt/ https://pypi.org/project/PyQt5/"

MY_P=${PN}-${PV/_pre/.dev}
if [[ ${PV} == *_pre* ]]; then
	SRC_URI="https://dev.gentoo.org/~pesa/distfiles/${MY_P}.tar.gz"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"
fi
S=${WORKDIR}/${MY_P}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"

# TODO: QtNfc, QtQuick3D, QtRemoteObjects
IUSE="bluetooth dbus debug declarative designer examples gles2-only gui help location
	multimedia network opengl positioning printsupport sensors serialport speech
	sql +ssl svg testlib webchannel websockets widgets x11extras xmlpatterns"

# The requirements below were extracted from the qmake_QT declarations
# in project.py and from the output of 'grep -r "%Import " ${S}/sip'
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
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

DEPEND="${PYTHON_DEPS}
	>=dev-qt/qtcore-${QT_PV}
	>=dev-qt/qtxml-${QT_PV}
	bluetooth? ( >=dev-qt/qtbluetooth-${QT_PV} )
	dbus? (
		dev-python/dbus-python[${PYTHON_USEDEP}]
		>=dev-qt/qtdbus-${QT_PV}
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
RDEPEND="${DEPEND}
	>=dev-python/PyQt5-sip-12.11:=[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/PyQt-builder-1.10[${PYTHON_USEDEP}]
	>=dev-python/sip-6.6.2[${PYTHON_USEDEP}]
	>=dev-qt/qtcore-${QT_PV}
	dbus? ( virtual/pkgconfig )
"

src_configure() {
	pyqt_use_enable() {
		use "$1" || return

		if [[ $# -eq 1 ]]; then
			echo --enable=Qt${1^}
		else
			shift
			echo ${@/#/--enable=}
		fi
	}

	configuration() {
		local myconf=(
			sip-build
			--verbose
			--confirm-license
			--build-dir="${BUILD_DIR}"
			--scripts-dir="$(python_get_scriptdir)"
			--qmake="$(qt5_get_bindir)"/qmake
			--no-make
			$(usev debug '--debug --qml-debug --tracing')
			$(usev !dbus --no-dbus-python)
			$(usev !declarative --no-qml-plugin)
			$(usev !designer --no-designer-plugin)
			$(usev gles2-only --disabled-feature=PyQt_Desktop_OpenGL)
			$(usev !ssl --disabled-feature=PyQt_SSL)
			--enable=pylupdate
			--enable=pyrcc
			--enable=Qt
			$(pyqt_use_enable bluetooth)
			--enable=QtCore
			$(pyqt_use_enable dbus QtDBus)
			$(pyqt_use_enable declarative QtQml QtQuick $(usev widgets QtQuickWidgets))
			$(pyqt_use_enable designer)
			$(pyqt_use_enable gui)
			$(pyqt_use_enable gui $(use gles2-only && echo _QOpenGLFunctions_ES2 || echo _QOpenGLFunctions_{2_0,2_1,4_1_Core}))
			$(pyqt_use_enable help)
			$(pyqt_use_enable location)
			$(pyqt_use_enable multimedia QtMultimedia $(usev widgets QtMultimediaWidgets))
			$(pyqt_use_enable network)
			$(pyqt_use_enable opengl QtOpenGL)
			$(pyqt_use_enable positioning)
			$(pyqt_use_enable printsupport QtPrintSupport)
			$(pyqt_use_enable sensors)
			$(pyqt_use_enable serialport QtSerialPort)
			$(pyqt_use_enable speech QtTextToSpeech)
			$(pyqt_use_enable sql)
			$(pyqt_use_enable svg)
			$(pyqt_use_enable testlib QtTest)
			$(pyqt_use_enable webchannel QtWebChannel)
			$(pyqt_use_enable websockets QtWebSockets)
			$(pyqt_use_enable widgets)
			$(pyqt_use_enable x11extras QtX11Extras)
			--enable=QtXml
			$(pyqt_use_enable xmlpatterns QtXmlPatterns)
		)
		echo "${myconf[@]}"
		"${myconf[@]}" || die

		# Run eqmake to respect toolchain and build flags
		run_in_build_dir eqmake5 -recursive ${PN}.pro
	}
	python_foreach_impl configuration
}

src_compile() {
	python_foreach_impl run_in_build_dir default
}

src_install() {
	installation() {
		emake INSTALL_ROOT="${D}" install
		python_optimize

		local exe
		for exe in "${D}$(python_get_scriptdir)"/*; do
			python_doexe "${exe}"
		done
	}
	python_foreach_impl run_in_build_dir installation

	einstalldocs

	if use examples; then
		dodoc -r examples
	fi
}

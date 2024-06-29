# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=sip
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1 flag-o-matic multiprocessing pypi qmake-utils

# 'can' work with older Qt depending on features, but keeping it simple
QT_PV=$(ver_cut 1-2):6

DESCRIPTION="Python bindings for the Qt framework"
HOMEPAGE="https://www.riverbankcomputing.com/software/pyqt/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv"
# defaults match what is provided with qtbase by default (except testlib),
# reduces the need to set flags but does increase build time a fair amount
IUSE="
	bluetooth +dbus debug designer examples gles2-only +gui help
	multimedia +network nfc opengl pdfium positioning +printsupport
	qml quick quick3d serialport sensors spatialaudio speech +sql
	+ssl svg testlib webchannel websockets +widgets +xml
"
# see `grep -r "%Import " sip` and `grep qmake_QT project.py`
REQUIRED_USE="
	designer? ( gui widgets )
	help? ( gui widgets )
	multimedia? ( gui network )
	opengl? ( gui )
	pdfium? ( gui )
	printsupport? ( gui widgets )
	qml? ( network )
	quick3d? ( gui qml )
	quick? ( gui qml )
	spatialaudio? ( multimedia )
	sql? ( widgets )
	svg? ( gui )
	testlib? ( gui widgets )
	webchannel? ( network )
	websockets? ( network )
	widgets? ( gui )
"

# may use qt private symbols wrt qtbase's :=
DEPEND="
	>=dev-qt/qtbase-${QT_PV}=[dbus?,gles2-only=,gui?,network?,opengl?,sql?,ssl=,widgets?,xml?]
	bluetooth? ( >=dev-qt/qtconnectivity-${QT_PV}[bluetooth] )
	dbus? (
		dev-python/dbus-python[${PYTHON_USEDEP}]
		sys-apps/dbus
	)
	designer? ( >=dev-qt/qttools-${QT_PV}[designer] )
	help? ( >=dev-qt/qttools-${QT_PV}[assistant] )
	multimedia? ( >=dev-qt/qtmultimedia-${QT_PV} )
	nfc? ( >=dev-qt/qtconnectivity-${QT_PV}[nfc] )
	opengl? (
		gles2-only? ( media-libs/libglvnd )
	)
	pdfium? ( >=dev-qt/qtwebengine-${QT_PV}[pdfium,widgets?] )
	positioning? ( >=dev-qt/qtpositioning-${QT_PV} )
	qml? ( >=dev-qt/qtdeclarative-${QT_PV}[widgets?] )
	quick3d? ( >=dev-qt/qtquick3d-${QT_PV} )
	quick? ( >=dev-qt/qtdeclarative-${QT_PV}[opengl] )
	sensors? ( >=dev-qt/qtsensors-${QT_PV} )
	serialport? ( >=dev-qt/qtserialport-${QT_PV} )
	speech? (
		>=dev-qt/qtdeclarative-${QT_PV}
		>=dev-qt/qtspeech-${QT_PV}
	)
	svg? ( >=dev-qt/qtsvg-${QT_PV} )
	webchannel? ( >=dev-qt/qtwebchannel-${QT_PV} )
	websockets? ( >=dev-qt/qtwebsockets-${QT_PV} )
"
RDEPEND="
	${DEPEND}
	>=dev-python/PyQt6-sip-13.6[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/PyQt-builder-1.15[${PYTHON_USEDEP}]
	>=dev-python/sip-6.8[${PYTHON_USEDEP}]
	>=dev-qt/qtbase-${QT_PV}
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
	append-cxxflags -std=c++17 # for old gcc / clang that use <17 (bug #892331)
	append-cxxflags ${CPPFLAGS} # respect CPPFLAGS notably for DISTUTILS_EXT=1

	pyqt_use_enable() {
		local state=$(usex ${1} --enable= --disable=)
		shift
		echo ${*/#/${state}}
	}

	DISTUTILS_ARGS=(
		--jobs="$(makeopts_jobs)"
		--qmake="$(qt6_get_bindir)"/qmake
		--qmake-setting="$(qt6_get_qmake_args)"
		--verbose
		--confirm-license

		--enable=QtCore

		$(pyqt_use_enable bluetooth QtBluetooth)
		$(pyqt_use_enable dbus QtDBus)
		$(pyqt_use_enable designer QtDesigner)
		$(pyqt_use_enable help QtHelp)
		$(pyqt_use_enable gui QtGui)
		#--disable=QtLocation # force-disabled in project.py
		$(pyqt_use_enable multimedia QtMultimedia \
			$(usev widgets QtMultimediaWidgets))
		$(pyqt_use_enable network QtNetwork)
		$(pyqt_use_enable nfc QtNfc)
		$(pyqt_use_enable opengl QtOpenGL \
			$(usev widgets QtOpenGLWidgets))
		$(pyqt_use_enable pdfium QtPdf \
			$(usev widgets QtPdfWidgets))
		$(pyqt_use_enable positioning QtPositioning)
		$(pyqt_use_enable printsupport QtPrintSupport)
		$(pyqt_use_enable qml QtQml)
		$(pyqt_use_enable quick QtQuick \
			$(usev widgets QtQuickWidgets))
		$(pyqt_use_enable quick3d QtQuick3D)
		--disable=QtRemoteObjects # not packaged
		$(pyqt_use_enable sensors QtSensors)
		$(pyqt_use_enable serialport QtSerialPort)
		$(pyqt_use_enable spatialaudio QtSpatialAudio)
		$(pyqt_use_enable sql QtSql)
		$(pyqt_use_enable svg QtSvg \
			$(usev widgets QtSvgWidgets))
		$(pyqt_use_enable testlib QtTest)
		$(pyqt_use_enable speech QtTextToSpeech)
		$(pyqt_use_enable webchannel QtWebChannel)
		$(pyqt_use_enable websockets QtWebSockets)
		$(pyqt_use_enable widgets QtWidgets)
		$(pyqt_use_enable xml QtXml)

		$(usev debug '--debug --qml-debug --tracing')

		$(usev !dbus --no-dbus-python)
		# note: upstream currently intentionally skips installing these two
		# plugins when using wheels w/ pep517 so, *if* something does need
		# them, it will need to be handled manually
		$(usev !designer --no-designer-plugin)
		$(usev !qml --no-qml-plugin)

		$(usev !gles2-only --disabled-feature=PyQt_OpenGL_ES2)
		$(usev !opengl --disabled-feature=PyQt_OpenGL)
		$(usev !ssl --disabled-feature=PyQt_SSL)

		# intended for Windows / Android or others
		--disable=QAxContainer
		--disabled-feature=PyQt_Permissions
	)
}

python_install_all() {
	einstalldocs
	use examples && dodoc -r examples
}

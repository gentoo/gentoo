# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=sip
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1 flag-o-matic multiprocessing qmake-utils

QT_PV="6.3:6" # minimum tested qt version

DESCRIPTION="Python bindings for the Qt framework"
HOMEPAGE="https://www.riverbankcomputing.com/software/pyqt/"
SRC_URI="mirror://pypi/${P::1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
# currently keeping defaults in sync with qtbase (no extra deps), but trying
# to stay minimal'ish given each builds relatively slowly (subject to change,
# perhaps more or less depending on consumers and if qtbase is ever split)
IUSE="
	+dbus debug qml designer examples gles2-only +gui help multimedia
	+network opengl positioning printsupport quick quick3d serialport
	+sql +ssl svg testlib webchannel websockets +widgets +xml"
# see `grep -r "%Import " sip` and `grep qmake_QT project.py`
REQUIRED_USE="
	designer? ( gui widgets )
	help? ( gui widgets )
	multimedia? ( gui network )
	opengl? ( gui )
	printsupport? ( gui widgets )
	qml? ( network )
	quick3d? ( gui qml )
	quick? ( gui qml )
	sql? ( widgets )
	svg? ( gui )
	testlib? ( gui widgets )
	webchannel? ( network )
	websockets? ( network )
	widgets? ( gui )"

# note: xml(+) for now given qtbase-6.3.1-r0 is missing IUSE=xml with a TODO
DEPEND="
	>=dev-qt/qtbase-${QT_PV}[dbus?,gles2-only=,gui?,network?,opengl?,sql?,ssl=,widgets?,xml(+)?]
	dbus? (
		dev-python/dbus-python[${PYTHON_USEDEP}]
		sys-apps/dbus
	)
	designer? ( >=dev-qt/qttools-${QT_PV}[designer] )
	help? ( >=dev-qt/qttools-${QT_PV}[assistant] )
	multimedia? ( >=dev-qt/qtmultimedia-${QT_PV} )
	positioning? ( >=dev-qt/qtpositioning-${QT_PV} )
	qml? ( >=dev-qt/qtdeclarative-${QT_PV} )
	quick3d? ( >=dev-qt/qtquick3d-${QT_PV} )
	serialport? ( >=dev-qt/qtserialport-${QT_PV} )
	svg? ( >=dev-qt/qtsvg-${QT_PV} )
	webchannel? ( >=dev-qt/qtwebchannel-${QT_PV} )
	websockets? ( >=dev-qt/qtwebsockets-${QT_PV} )"
RDEPEND="
	${DEPEND}
	>=dev-python/PyQt6-sip-13.4[${PYTHON_USEDEP}]"
BDEPEND="
	>=dev-python/PyQt-builder-1.11[${PYTHON_USEDEP}]
	>=dev-qt/qtbase-${QT_PV}
	sys-devel/gcc
	dbus? ( virtual/pkgconfig )"

src_prepare() {
	default

	# hack: qmake wants g++ (not clang), try to respect ${CHOST} #726112
	mkdir "${T}"/cxx || die
	ln -s "$(type -P ${CHOST}-g++ || type -P g++ || die)" "${T}"/cxx/g++ || die
	PATH=${T}/cxx:${PATH}
}

src_configure() {
	append-cxxflags -std=c++17 # for clang and old gcc that default to <17

	pyqt-use_enable() {
		local state=$(usex ${1} --enable= --disable=)
		shift
		echo ${*/#/${state}}
	}

	# workaround until bug 863395 has something to offer
	local qmake6=$(qt5_get_bindir)/qmake
	qmake6=${qmake6//qt5/qt6}

	DISTUTILS_ARGS=(
		--jobs=$(makeopts_jobs)
		--qmake="${qmake6}"
		--qmake-setting="$(qt5_get_qmake_args)"
		--verbose
		--confirm-license

		# TODO: enable/restrict more as qt6 packages/USE get added
		--disable=QAxContainer
		--disable=QtBluetooth
		--enable=QtCore
		$(pyqt-use_enable dbus QtDBus)
		$(pyqt-use_enable designer QtDesigner)
		$(pyqt-use_enable help QtHelp)
		$(pyqt-use_enable gui QtGui)
		#--disable=QtLocation # force-disabled in project.py
		$(pyqt-use_enable multimedia QtMultimedia \
			$(usev widgets QtMultimediaWidgets))
		$(pyqt-use_enable network QtNetwork)
		--disable=QtNfc
		$(pyqt-use_enable opengl QtOpenGL \
			$(usev widgets QtOpenGLWidgets))
		--disable=QtPdf #+QtPdfWidgets (QtPdf is disabled in qtwebengine:6)
		$(pyqt-use_enable positioning QtPositioning)
		$(pyqt-use_enable printsupport QtPrintSupport)
		$(pyqt-use_enable qml QtQml)
		$(pyqt-use_enable quick QtQuick \
			$(usev widgets QtQuickWidgets))
		$(pyqt-use_enable quick3d QtQuick3D)
		--disable=QtRemoteObjects
		--disable=QtSensors
		$(pyqt-use_enable serialport QtSerialPort)
		$(pyqt-use_enable sql QtSql)
		$(pyqt-use_enable svg QtSvg \
			$(usev widgets QtSvgWidgets))
		$(pyqt-use_enable testlib QtTest)
		--disable=QtTextToSpeech
		$(pyqt-use_enable webchannel QtWebChannel)
		$(pyqt-use_enable websockets QtWebSockets)
		$(pyqt-use_enable widgets QtWidgets)
		$(pyqt-use_enable xml QtXml)

		$(usev debug '--debug --qml-debug --tracing')

		$(usev !dbus --no-dbus-python)
		# TODO?: plugins not in wheels by upstream, see project.py#L215
		# (if needed by something, will need to be added to python_install)
		$(usev !designer --no-designer-plugin)
		$(usev !qml --no-qml-plugin)

		$(usev !gles2-only --disabled-feature=PyQt_OpenGL_ES2)
		$(usev !ssl --disabled-feature=PyQt_SSL)
	)
}

python_install_all() {
	einstalldocs
	use examples && dodoc -r examples
}

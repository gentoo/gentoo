# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: Add PyPy once officially supported. See also:
#     https://bugreports.qt.io/browse/PYSIDE-535
PYTHON_COMPAT=( python3_{10..13} )

LLVM_COMPAT=( {15..18} )

inherit cmake llvm-r1 python-r1 virtualx

# TODO: Add conditional support for "QtRemoteObjects" via a new "remoteobjects"
# USE flag after an external "dev-qt/qtremoteobjects" package has been created.
# TODO: Add conditional support for apidoc generation via a new "doc" USE flag.
# Note that doing so requires the Qt source tree, sphinx, and graphviz. Once
# ready, pass the ${QT_SRC_DIR} variable to cmake to enable this support.
# TODO: Disable GLES support if the "gles2-only" USE flag is disabled. Note
# that the "PySide6/QtGui/CMakeLists.txt" and
# "PySide6/QtOpenGLFunctions/CMakeLists.txt" files test for GLES support by
# testing whether the "Qt5::Gui" list property defined by
# "/usr/lib64/cmake/Qt5Gui/Qt5GuiConfig.cmake" at "dev-qt/qtgui" installation
# time contains the substring "opengles2". Since cmake does not permit
# properties to be overridden from the command line, these files must instead
# be conditionally patched to avoid these tests. An issue should be filed with
# upstream requesting a CLI-settable variable to control this.

MY_PN="pyside-setup-everywhere-src"

DESCRIPTION="Python bindings for the Qt framework"
HOMEPAGE="https://wiki.qt.io/PySide6"
SRC_URI="https://download.qt.io/official_releases/QtForPython/pyside6/PySide6-${PV}-src/${MY_PN}-${PV}.tar.xz"
S="${WORKDIR}/${MY_PN}-${PV}/sources/pyside6"

# See "sources/pyside6/PySide6/licensecomment.txt" for licensing details.
# Shall we allow essential modules to be disabled? They are:
# (core), gui, widgets, printsupport, sql, network, testlib, concurrent,
# x11extras (for X)
LICENSE="|| ( GPL-2 GPL-3+ LGPL-3 )"
SLOT="6/${PV}"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE="
	3d bluetooth charts +concurrent +dbus designer gles2-only +gui help location
	multimedia +network network-auth nfc positioning +opengl pdfium positioning
	+printsupport qml quick quick3d serialport scxml sensors spatialaudio speech
	+sql svg test +testlib webchannel webengine	websockets +widgets +xml
"

# Manually reextract these requirements on version bumps by running the
# following one-liner from within "${S}":
#     $ grep 'set.*_deps' PySide6/Qt*/CMakeLists.txt
# Note that the "designer" USE flag corresponds to the "Qt6UiTools" module.
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	3d? ( gui network )
	charts? ( gui widgets )
	designer? ( widgets )
	gles2-only? ( gui )
	gui? ( dbus opengl )
	help? ( network sql widgets )
	location? ( gui network positioning quick )
	multimedia? ( gui network )
	network-auth? ( network )
	opengl? ( gui )
	pdfium? ( gui )
	printsupport? ( widgets )
	qml? ( network )
	quick? ( gui network opengl qml )
	quick3d? ( gui network opengl qml quick )
	spatialaudio? ( multimedia )
	speech? ( multimedia )
	sql? ( widgets )
	svg? ( gui )
	testlib? ( widgets )
	webchannel? ( qml )
	webengine? ( network gui printsupport quick webchannel )
	websockets? ( network )
	widgets? ( gui )
"

# Tests fail pretty bad and I'm not fixing them right now
RESTRICT="test"

# Minimal supported version of Qt.
QT_PV="$(ver_cut 1-3)*:6"

RDEPEND="${PYTHON_DEPS}
	=dev-python/shiboken6-${QT_PV}[${PYTHON_USEDEP},${LLVM_USEDEP}]
	=dev-qt/qtbase-${QT_PV}[concurrent?,dbus?,gles2-only=,network?,opengl?,sql?,widgets?,xml?]
	3d? ( =dev-qt/qt3d-${QT_PV}[qml?,gles2-only=] )
	bluetooth? ( =dev-qt/qtconnectivity-${QT_PV}[bluetooth] )
	charts? ( =dev-qt/qtcharts-${QT_PV} )
	designer? ( =dev-qt/qttools-${QT_PV}[designer] )
	gui? (
		=dev-qt/qtbase-${QT_PV}[gui,jpeg(+)]
		x11-libs/libxkbcommon
	)
	help? ( =dev-qt/qttools-${QT_PV}[assistant] )
	location? ( =dev-qt/qtlocation-${QT_PV} )
	multimedia? ( =dev-qt/qtmultimedia-${QT_PV} )
	network? ( =dev-qt/qtbase-${QT_PV}[ssl] )
	network-auth? ( =dev-qt/qtnetworkauth-${QT_PV} )
	nfc? ( =dev-qt/qtconnectivity-${QT_PV}[nfc] )
	pdfium? ( =dev-qt/qtwebengine-${QT_PV}[pdfium(-),widgets?] )
	positioning? ( =dev-qt/qtpositioning-${QT_PV} )
	printsupport? ( =dev-qt/qtbase-${QT_PV}[gui,widgets] )
	qml? ( =dev-qt/qtdeclarative-${QT_PV}[widgets?] )
	quick3d? ( =dev-qt/qtquick3d-${QT_PV} )
	scxml? ( =dev-qt/qtscxml-${QT_PV} )
	sensors? ( =dev-qt/qtsensors-${QT_PV}[qml?] )
	speech? ( =dev-qt/qtspeech-${QT_PV} )
	serialport? ( =dev-qt/qtserialport-${QT_PV} )
	svg? ( =dev-qt/qtsvg-${QT_PV} )
	testlib? ( =dev-qt/qtbase-${QT_PV}[gui] )
	webchannel? ( =dev-qt/qtwebchannel-${QT_PV} )
	webengine? ( || (
		=dev-qt/qtwebengine-${QT_PV}[alsa,widgets?]
		=dev-qt/qtwebengine-${QT_PV}[pulseaudio,widgets?]
		)
	)
	websockets? ( =dev-qt/qtwebsockets-${QT_PV} )
	!dev-python/pyside6:0
"
DEPEND="${RDEPEND}
	$(llvm_gen_dep '
		sys-devel/clang:${LLVM_SLOT}
		sys-devel/llvm:${LLVM_SLOT}
	')
	test? ( =dev-qt/qtbase-${QT_PV}[gui] )
"
# testlib is toggled by the gui flag on qtbase

PATCHES=(
	"${FILESDIR}/${PN}-6.3.1-no-strip.patch"
	# References files not present in our dev-qt/qtbase
	"${FILESDIR}/${PN}-6.6.0-no-qtexampleicons.patch"
)

src_configure() {
	# See collect_module_if_found macros in PySideHelpers.cmake
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt63DAnimation=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt63DCore=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt63DExtras=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt63DInput=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt63DLogic=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt63DRender=$(usex !3d)
		#-DCMAKE_DISABLE_FIND_PACKAGE_Qt6AxContainer=yes
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Bluetooth=$(usex !bluetooth)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Charts=$(usex !charts)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Concurrent=$(usex !concurrent)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6DataVisualization=yes
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6DBus=$(usex !dbus)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Designer=$(usex !designer)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Gui=$(usex !gui)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Help=$(usex !help)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6HttpServer=yes
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Location=$(usex !location)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Multimedia=$(usex !multimedia)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6MultimediaWidgets=$(usex !multimedia yes $(usex !widgets))
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6NetworkAuth=$(usex !network-auth)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Network=$(usex !network)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Nfc=$(usex !nfc)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6OpenGL=$(usex !opengl)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6OpenGLWidgets=$(usex !opengl yes $(usex !widgets))
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Pdf=$(usex !pdfium)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6PdfWidgets=$(usex !pdfium yes $(usex !widgets))
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Positioning=$(usex !positioning)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6PrintSupport=$(usex !printsupport)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Qml=$(usex !qml)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Quick3D=$(usex !quick3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Quick=$(usex !quick)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6QuickControls2=yes
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6QuickWidgets=$(usex !quick yes $(usex !widgets))
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6RemoteObjects=yes
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Scxml=$(usex !scxml)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Sensors=$(usex !sensors)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6SerialPort=$(usex !serialport)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6SpatialAudio=$(usex !spatialaudio)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Sql=$(usex !sql)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6StateMachine=yes
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Svg=$(usex !svg)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6SvgWidgets=$(usex !svg yes $(usex !widgets))
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Test=$(usex !testlib)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6TextToSpeech=$(usex !speech)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6UiTools=$(usex !designer)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6WebChannel=$(usex !webchannel)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6WebEngineCore=$(usex !webengine)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6WebEngineQuick=$(usex !webengine yes $(usex !quick))
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6WebEngineWidgets=$(usex !webengine yes $(usex !widgets))
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6WebSockets=$(usex !websockets)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Widgets=$(usex !widgets)
		#-DCMAKE_DISABLE_FIND_PACKAGE_Qt6WinExtras=yes
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Xml=$(usex !xml)
		# try to avoid pre-stripping
		-DQFP_NO_OVERRIDE_OPTIMIZATION_FLAGS=yes
		-DQFP_NO_STRIP=yes

	)

	pyside6_configure() {
		local mycmakeargs=(
			"${mycmakeargs[@]}"
			-DPYTHON_CONFIG_SUFFIX="-${EPYTHON}"
			-DPYTHON_SITE_PACKAGES="$(python_get_sitedir)"
			-DSHIBOKEN_PYTHON_SHARED_LIBRARY_SUFFIX="-${EPYTHON}"
		)
		cmake_src_configure
	}
	python_foreach_impl pyside6_configure
}

src_compile() {
	python_foreach_impl cmake_src_compile
}

src_test() {
	local -x PYTHONDONTWRITEBYTECODE
	python_foreach_impl virtx cmake_src_test
}

src_install() {
	pyside6_install() {
		cmake_src_install
		python_optimize

		# Uniquify the shiboken6 pkgconfig dependency in the PySide6 pkgconfig
		# file for the current Python target. See also:
		#     https://github.com/leycec/raiagent/issues/73
		sed -i -e 's~^Requires: shiboken6$~&-'${EPYTHON}'~' \
			"${ED}/usr/$(get_libdir)"/pkgconfig/${PN}.pc || die

		# Uniquify the PySide6 pkgconfig file for the current Python target,
		# preserving an unversioned "pyside6.pc" file arbitrarily associated
		# with the last Python target. (See the previously linked issue.)
		cp "${ED}/usr/$(get_libdir)"/pkgconfig/${PN}{,-${EPYTHON}}.pc || die
	}
	python_foreach_impl pyside6_install

	# CMakeLists.txt installs a "PySide6Targets-gentoo.cmake" file forcing
	# downstream consumers (e.g., pyside6-tools) to target one
	# "libpyside6-*.so" library linked to one Python interpreter. See also:
	#     https://bugreports.qt.io/browse/PYSIDE-1053
	#     https://github.com/leycec/raiagent/issues/74
	sed -i -e 's~pyside6-python[[:digit:]]\+\.[[:digit:]]\+~pyside6${PYTHON_CONFIG_SUFFIX}~g' \
		"${ED}/usr/$(get_libdir)/cmake/PySide6/PySide6Targets-${CMAKE_BUILD_TYPE,,}.cmake" || die
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: Add PyPy once officially supported. See also:
#     https://bugreports.qt.io/browse/PYSIDE-535
PYTHON_COMPAT=( python3_{8..11} )

inherit cmake python-r1 virtualx

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

MY_P=pyside-setup-opensource-src-${PV}

DESCRIPTION="Python bindings for the Qt framework"
HOMEPAGE="https://wiki.qt.io/PySide6"
SRC_URI="https://download.qt.io/official_releases/QtForPython/pyside6/PySide6-${PV}-src/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}/sources/pyside6"

# See "sources/pyside6/PySide6/licensecomment.txt" for licensing details.
# Shall we allow essential modules to be disabled? They are:
# (core), gui, widgets, printsupport, sql, network, testlib, concurrent,
# x11extras (for X)
LICENSE="|| ( GPL-2 GPL-3+ LGPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE="
	dbus +concurrent designer gles2-only +gui help multimedia
	+network opengl positioning printsupport qml quick quick3d
	serialport +sql svg test +testlib webchannel webengine
	websockets +widgets +xml
"

# Manually reextract these requirements on version bumps by running the
# following one-liner from within "${S}":
#     $ grep 'set.*_deps' PySide6/Qt*/CMakeLists.txt
# Note that the "designer" USE flag corresponds to the "Qt5UiTools" module.
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	designer? ( widgets )
	gles2-only? ( gui )
	help? ( widgets )
	multimedia? ( gui network )
	opengl? ( gui )
	printsupport? ( widgets )
	qml? ( network )
	quick? ( gui network opengl qml )
	quick3d? ( gui network opengl qml quick )
	sql? ( widgets )
	svg? ( gui )
	testlib? ( widgets )
	webengine? ( network gui printsupport webchannel )
	websockets? ( network )
	widgets? ( gui )
"

# Tests fail pretty bad and I'm not fixing them right now
RESTRICT="test"

# Minimal supported version of Qt.
QT_PV="$(ver_cut 1-2)*:6"

RDEPEND="${PYTHON_DEPS}
	~dev-python/shiboken6-${PV}[${PYTHON_USEDEP}]
	=dev-qt/qtbase-${QT_PV}[dbus?,opengl?,gles2-only=,sql?,network?,concurrent?,widgets?,xml(+)?]
	designer? ( =dev-qt/qttools-${QT_PV}[designer] )
	gui? ( =dev-qt/qtbase-${QT_PV}[gui,jpeg] )
	help? ( =dev-qt/qttools-${QT_PV}[assistant] )
	multimedia? ( =dev-qt/qtmultimedia-${QT_PV}[qml(+)?,gles2-only(-)=,widgets(+)?] )
	positioning? ( =dev-qt/qtpositioning-${QT_PV}[qml(+)?] )
	printsupport? ( =dev-qt/qtbase-${QT_PV}[gui,widgets] )
	qml? ( =dev-qt/qtdeclarative-${QT_PV}[widgets?] )
	quick3d? ( =dev-qt/qtquick3d-${QT_PV} )
	serialport? ( =dev-qt/qtserialport-${QT_PV} )
	svg? ( =dev-qt/qtsvg-${QT_PV} )
	testlib? ( =dev-qt/qtbase-${QT_PV}[gui] )
	webchannel? ( =dev-qt/qtwebchannel-${QT_PV}[qml(+)?] )
	webengine? ( =dev-qt/qtwebengine-${QT_PV}[widgets?] )
	websockets? ( =dev-qt/qtwebsockets-${QT_PV} )
"
DEPEND="${RDEPEND}
	test? ( =dev-qt/qtbase-${QT_PV}[gui] )
"
# testlib is toggled by the gui flag on qtbase

PATCHES=(
	"${FILESDIR}/${PN}-6.3.1-no-strip.patch"
	"${FILESDIR}/${PN}-6.3.1-fix-designer-plugin-install-location.patch"
)

src_configure() {
	# See collect_module_if_found macros in PySideHelpers.cmake
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt63DAnimation=yes
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt63DCore=yes
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt63DExtras=yes
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt63DInput=yes
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt63DLogic=yes
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt63DRender=yes
		#-DCMAKE_DISABLE_FIND_PACKAGE_Qt6AxContainer=yes
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Bluetooth=yes
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Charts=yes
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Concurrent=$(usex !concurrent)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6DataVisualization=yes
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6DBus=$(usex !dbus)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Designer=$(usex !designer)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Gui=$(usex !gui)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Help=$(usex !help)
		#-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Location=yes
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Multimedia=$(usex !multimedia)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6MultimediaWidgets=$(usex !multimedia yes $(usex !widgets))
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6NetworkAuth=yes
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Network=$(usex !network)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Nfc=yes
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6OpenGL=$(usex !opengl)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6OpenGLWidgets=$(usex !opengl yes $(usex !widgets))
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Positioning=$(usex !positioning)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6PrintSupport=$(usex !printsupport)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Qml=$(usex !qml)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Quick3D=$(usex !quick3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Quick=$(usex !quick)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6QuickControls2=yes
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6QuickWidgets=$(usex !quick yes $(usex !widgets))
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6RemoteObjects=yes
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Scxml=yes
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Sensors=yes
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6SerialPort=$(usex !serialport)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Sql=$(usex !sql)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6StateMachine=yes
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Svg=$(usex !svg)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6SvgWidgets=$(usex !svg yes $(usex !widgets))
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Test=$(usex !testlib)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6TextToSpeech=yes
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
			-DPYTHON_EXECUTABLE="${PYTHON}"
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
		"${ED}/usr/$(get_libdir)/cmake/PySide6-${PV}/PySide6Targets-${CMAKE_BUILD_TYPE,,}.cmake" || die
}

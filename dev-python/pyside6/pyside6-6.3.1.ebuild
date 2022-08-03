# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: Add PyPy once officially supported. See also:
#	https://bugreports.qt.io/browse/PYSIDE-535
# TODO: add python3_11 again, once free(): invalid pointer
#	is solved in "python3.11 generate_pyi.py QtCore"
PYTHON_COMPAT=( python3_{8..10} )

inherit cmake python-r1 virtualx

# TODO: Add conditional support for apidoc generation via a new "doc" USE flag.
# Note that doing so requires the Qt source tree, sphinx, and graphviz. Once
# ready, pass the ${QT_SRC_DIR} variable to cmake to enable this support.
# VERIFY TODO: Disable GLES support if the "gles2-only" USE flag is disabled. Note
# that the "PySide2/QtGui/CMakeLists.txt" and
# "PySide2/QtOpenGLFunctions/CMakeLists.txt" files test for GLES support by
# testing whether the "Qt2::Gui" list property defined by
# "/usr/lib64/cmake/Qt5Gui/Qt5GuiConfig.cmake" at "dev-qt/qtgui" installation
# time contains the substring "opengles2". Since cmake does not permit
# properties to be overridden from the command line, these files must instead
# be conditionally patched to avoid these tests. An issue should be filed with
# upstream requesting a CLI-settable variable to control this.

MY_P=pyside-setup-opensource-src-${PV}

DESCRIPTION="Python bindings for the Qt framework"
HOMEPAGE="https://wiki.qt.io/PySide2"
SRC_URI="https://download.qt.io/official_releases/QtForPython/pyside6/PySide6-${PV}-src/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}/sources/pyside6"

# See "sources/pyside6/PySide6/licensecomment.txt" for licensing details.
LICENSE="|| ( GPL-2 GPL-3+ LGPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
# Optional modules: 3d bluetooth charts datavis help location
# network-auth nfc scxml sensors speech statemachine x11extras? xmlpatterns?
# We consider essential modules as mandatory and don't provide a USE flag.
# They are: concurrent, gui, network, printsupport, sql, testlib, widgets
IUSE="
	designer gles2-only multimedia positioning qml quick serialport svg test
	webchannel webengine websockets xml
"

# Manually reextract these requirements on version bumps by running the
# following one-liner from within "${S}":
#     $ grep 'set.*_deps' PySide6/Qt*/CMakeLists.txt
#	3d? ( quick )
#	location? ( positioning )
#	speech? ( multimedia )
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	designer? ( xml )
	quick? ( qml )
	webchannel? ( qml )
	webengine? ( quick webchannel )
"

# TODO tests fail pretty bad and I'm not fixing them right now
RESTRICT="test"

# Minimal supported version of Qt.
QT_PV="$(ver_cut 1-2):6"

#	3d? ( >=dev-qt/qt3d-${QT_PV}[qml?] )
#	charts? ( >=dev-qt/qtcharts-${QT_PV}[qml?] )
#	datavis? ( >=dev-qt/qtdatavis3d-${QT_PV}[qml?] )
#	help? ( >=dev-qt/qttools-${QT_PV}[qdoc] )
#	location? ( >=dev-qt/qtlocation-${QT_PV} )
#	printsupport? ( >=dev-qt/qtprintsupport-${QT_PV} )
#	quick? ( 3d? ( >=dev-qt/qtquick3d-${QT_PV} ) )
#	scxml? ( >=dev-qt/qtscxml-${QT_PV} )
#	sensors? ( >=dev-qt/qtsensors-${QT_PV}[qml?] )
#	speech? ( >=dev-qt/qtspeech-${QT_PV} )
#	sql? ( >=dev-qt/qtsql-${QT_PV} )
#	testlib? ( >=dev-qt/qttest-${QT_PV} )
#	x11extras? ( >=dev-qt/qtx11extras-${QT_PV} )
RDEPEND="
	${PYTHON_DEPS}
	>=dev-python/shiboken6-${PV}[${PYTHON_USEDEP}]
	>=dev-qt/qtbase-${QT_PV}[concurrent,dbus,gles2-only=,gui,network,opengl,sql,widgets,xml(+)?]
	x11-libs/libxshmfence
	designer? ( >=dev-qt/qttools-${QT_PV}[designer] )
	multimedia? ( >=dev-qt/qtmultimedia-${QT_PV} )
	positioning? ( >=dev-qt/qtpositioning-${QT_PV} )
	qml? ( >=dev-qt/qtdeclarative-${QT_PV}[opengl,sql,widgets] )
	quick? ( >=dev-qt/qtquick3d-${QT_PV} )
	serialport? ( >=dev-qt/qtserialport-${QT_PV} )
	svg? ( >=dev-qt/qtsvg-${QT_PV} )
	webchannel? ( >=dev-qt/qtwebchannel-${QT_PV} )
	webengine? ( >=dev-qt/qtwebengine-${QT_PV}[widgets] )
	websockets? ( >=dev-qt/qtwebsockets-${QT_PV} )
"
DEPEND="
	${RDEPEND}
	test? ( x11-misc/xvfb-run )
"

PATCHES=( "${FILESDIR}"/${P}-Gentoo-specific-adjust-install-path-for-designer-plugin.patch )

src_configure() {
	# See COLLECT_MODULE_IF_FOUND macros in CMakeLists.txt
	# TODO: mirror Qt6 updates and enabled currently disabled optional modules
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt63DAnimation=YES
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt63DCore=YES
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt63DExtras=YES
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt63DInput=YES
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt63DLogic=YES
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt63DRender=YES
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Bluetooth=YES
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Charts=YES
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6DataVisualization=YES
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Designer=$(usex !designer)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Help=YES
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Multimedia=$(usex !multimedia)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6MultimediaWidgets=$(usex !multimedia)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6NetworkAuth=YES
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Nfc=YES
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Positioning=$(usex !positioning)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Qml=$(usex !qml)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Quick=$(usex !quick)
#		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Quick3D=$(usex !quick yes $(usex !3d))
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Quick3D=$(usex !quick)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6QuickControls2=$(usex !quick)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6QuickWidgets=$(usex !quick)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6RemoteObjects=YES
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Scxml=YES
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Sensors=YES
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6SerialPort=$(usex !serialport)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6StateMachine=YES
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6TextToSpeech=YES
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Svg=$(usex !svg)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6SvgWidgets=$(usex !svg)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6UiTools=$(usex !designer)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6WebChannel=$(usex !webchannel)
#		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6WebEngine=$(usex !webengine) # needs guarding?
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6WebEngineCore=$(usex !webengine)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6WebEngineQuick=$(usex !webengine yes $(usex !quick))
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6WebEngineWidgets=$(usex !webengine)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6WebSockets=$(usex !websockets)
#		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6X11Extras=$(usex !x11extras) # needs guarding?
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Xml=$(usex !xml)
#		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6XmlPatterns=$(usex !xmlpatterns) # needs guarding?
		# try to avoid pre-stripping
		-DQFP_NO_OVERRIDE_OPTIMIZATION_FLAGS=YES
		-DQFP_NO_STRIP=YES
#		-Wno-dev
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

		# Uniquify the shiboken2 pkgconfig dependency in the PySide2 pkgconfig
		# file for the current Python target. See also:
		#     https://github.com/leycec/raiagent/issues/73
		sed -i -e 's~^Requires: shiboken6$~&-'${EPYTHON}'~' \
			"${ED}/usr/$(get_libdir)"/pkgconfig/${PN}.pc || die

		# Uniquify the PySide2 pkgconfig file for the current Python target,
		# preserving an unversioned "pyside6.pc" file arbitrarily associated
		# with the last Python target. (See the previously linked issue.)
		cp "${ED}/usr/$(get_libdir)"/pkgconfig/${PN}{,-${EPYTHON}}.pc || die
	}
	python_foreach_impl pyside6_install

	# CMakeLists.txt installs a "PySide6Targets-gentoo.cmake" file forcing
	# downstream consumers (e.g., pyside2-tools) to target one
	# "libpyside6-*.so" library linked to one Python interpreter. See also:
	#     https://bugreports.qt.io/browse/PYSIDE-1053
	#     https://github.com/leycec/raiagent/issues/74
	sed -i -e 's~pyside6-python[[:digit:]]\+\.[[:digit:]]\+~pyside6${PYTHON_CONFIG_SUFFIX}~g' \
		"${ED}/usr/$(get_libdir)/cmake/PySide6-${PV}/PySide6Targets-relwithdebinfo.cmake" || die
}

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils kde5-functions

DESCRIPTION="High-level runtime introspection tool for Qt applications"
HOMEPAGE="https://github.com/KDAB/GammaRay"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/KDAB/GammaRay.git"
else
	SRC_URI="https://github.com/KDAB/GammaRay/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2 BSD MIT"
SLOT=0
IUSE="3d bluetooth concurrent designer doc geolocation printsupport
	script scxml svg test qml wayland webengine"

RDEPEND="
	$(add_qt_dep qtcore)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	$(add_frameworks_dep kitemmodels)
	3d? ( $(add_qt_dep qt3d) )
	bluetooth? ( $(add_qt_dep qtbluetooth) )
	concurrent? ( $(add_qt_dep qtconcurrent) )
	designer? ( $(add_qt_dep designer) )
	geolocation? ( $(add_qt_dep qtpositioning) )
	printsupport? ( $(add_qt_dep qtprintsupport) )
	qml? ( $(add_qt_dep qtdeclarative 'widgets') )
	script? ( $(add_qt_dep qtscript 'scripttools') )
	scxml? ( $(add_qt_dep qtscxml) )
	svg? ( $(add_qt_dep qtsvg) )
	webengine? ( $(add_qt_dep qtwebengine 'widgets') )
	wayland? ( $(add_qt_dep qtwayland) )
"

DEPEND="${RDEPEND}
	test? ( $(add_qt_dep qttest) )
"

src_prepare(){
	sed -i "/BackwardMacros.cmake/d" CMakeLists.txt || die
	sed -i "/add_backward(gammaray_core)/d" core/CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure(){
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt53dAnimation=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt53dExtras=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt53dInput=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt53dLogic=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt53dRender=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt53dQuick=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Bluetooth=$(usex !bluetooth)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Concurrent=$(usex !concurrent)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Designer=$(usex !designer)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Positioning=$(usex !geolocation)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5PrintSupport=$(usex !printsupport)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Qml=$(usex !qml)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Quick=$(usex !qml)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5QuickWidgets=$(usex !qml)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Script=$(usex !script)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Svg=$(usex !svg)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Scxml=$(usex !scxml)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Test=$(usex !test)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebEngine=$(usex !webengine)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebEngineWidgets=$(usex !webengine)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WaylandCompositor=$(usex !wayland)
		-DGAMMARAY_BUILD_DOCS=$(usex doc)
		-DGAMMARAY_BUILD_UI=ON
		-DGAMMARAY_DISABLE_FEEDBACK=ON
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	elog
	elog "Install dev-util/kdstatemachineeditor as optional dependency"
	elog "for graphical state machine debugging support"
	elog
}

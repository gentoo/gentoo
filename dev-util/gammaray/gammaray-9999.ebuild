# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="High-level runtime introspection tool for Qt applications"
HOMEPAGE="https://github.com/KDAB/GammaRay"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/KDAB/GammaRay.git"
else
	SRC_URI="https://github.com/KDAB/GammaRay/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2+"
SLOT=0
IUSE="3d bluetooth concurrent designer doc geolocation printsupport
	script scxml svg test qml wayland webengine"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	kde-frameworks/kitemmodels:5
	3d? ( dev-qt/qt3d:5 )
	bluetooth? ( dev-qt/qtbluetooth:5 )
	concurrent? ( dev-qt/qtconcurrent:5 )
	designer? ( dev-qt/designer:5 )
	geolocation? ( dev-qt/qtpositioning:5 )
	printsupport? ( dev-qt/qtprintsupport:5 )
	qml? ( dev-qt/qtdeclarative:5[widgets] )
	script? ( dev-qt/qtscript:5[scripttools] )
	scxml? ( dev-qt/qtscxml:5 )
	svg? ( dev-qt/qtsvg:5 )
	webengine? ( dev-qt/qtwebengine:5[widgets] )
	wayland? ( dev-qt/qtwayland:5 )
"

DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )
"

src_prepare(){
	sed -i "/BackwardMacros.cmake/d" CMakeLists.txt || die
	sed -i "/add_backward(gammaray_core)/d" core/CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure(){
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt53DAnimation=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt53DExtras=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt53DInput=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt53DLogic=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt53DRender=$(usex !3d)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt53DQuick=$(usex !3d)
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
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WaylandCompositor=$(usex !wayland)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebEngineWidgets=$(usex !webengine)
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

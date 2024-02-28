# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_NONGUI="true"
ECM_QTHELP="true"
ECM_TEST="true"
KDE_ORG_TAR_PN="plasma-framework"
KFMIN=$(ver_cut 1-2)
QTMIN=5.15.9
inherit ecm frameworks.kde.org

DESCRIPTION="Plasma library and runtime components based upon KF5 and Qt5"

LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="gles2-only kf6compat man wayland"

RESTRICT="test"

# kde-frameworks/kwindowsystem[X]: Unconditional use of KX11Extras
COMMON_DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5[gles2-only=,X]
	>=dev-qt/qtquickcontrols-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	=kde-frameworks/karchive-${KFMIN}*:5
	=kde-frameworks/kconfig-${KFMIN}*:5[qml]
	=kde-frameworks/kconfigwidgets-${KFMIN}*:5
	=kde-frameworks/kcoreaddons-${KFMIN}*:5
	=kde-frameworks/kdeclarative-${KFMIN}*:5
	=kde-frameworks/kglobalaccel-${KFMIN}*:5
	=kde-frameworks/kguiaddons-${KFMIN}*:5
	=kde-frameworks/ki18n-${KFMIN}*:5
	=kde-frameworks/kiconthemes-${KFMIN}*:5
	=kde-frameworks/kio-${KFMIN}*:5
	=kde-frameworks/kirigami-${KFMIN}*:5
	=kde-frameworks/knotifications-${KFMIN}*:5
	=kde-frameworks/kpackage-${KFMIN}*:5
	=kde-frameworks/kservice-${KFMIN}*:5
	=kde-frameworks/kwidgetsaddons-${KFMIN}*:5
	=kde-frameworks/kwindowsystem-${KFMIN}*:5[X]
	=kde-frameworks/kxmlgui-${KFMIN}*:5
	=kde-plasma/plasma-activities-${KFMIN}*:5
	x11-libs/libX11
	x11-libs/libxcb
	!gles2-only? ( media-libs/libglvnd[X] )
	wayland? (
		=kde-plasma/kwayland-${KFMIN}*:5
		media-libs/libglvnd
	)
"
DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto
"
RDEPEND="${COMMON_DEPEND}
	kf6compat? ( kde-plasma/libplasma:6 )
"
BDEPEND="man? ( >=kde-frameworks/kdoctools-${KFMIN}:5 )"

src_configure() {
	local mycmakeargs=(
		-DBUILD_DESKTOPTHEMES=$(usex !kf6compat)
		$(cmake_use_find_package !gles2-only OpenGL)
		$(cmake_use_find_package man KF5DocTools)
		$(cmake_use_find_package wayland EGL)
		$(cmake_use_find_package wayland KF5Wayland)
	)

	ecm_src_configure
}

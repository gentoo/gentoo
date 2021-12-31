# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_ORG_NAME="${PN}-framework"
PVCUT=$(ver_cut 1-2)
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Plasma framework"

LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~x86"
IUSE="gles2 wayland X"

# drop qtgui subslot operator when QT_MINIMAL >= 5.14.0
BDEPEND="
	>=kde-frameworks/kdoctools-${PVCUT}:5
"
RDEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5=[gles2=]
	>=dev-qt/qtquickcontrols-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	=kde-frameworks/kactivities-${PVCUT}*:5
	=kde-frameworks/karchive-${PVCUT}*:5
	=kde-frameworks/kconfig-${PVCUT}*:5
	=kde-frameworks/kconfigwidgets-${PVCUT}*:5
	=kde-frameworks/kcoreaddons-${PVCUT}*:5
	=kde-frameworks/kdeclarative-${PVCUT}*:5
	=kde-frameworks/kglobalaccel-${PVCUT}*:5
	=kde-frameworks/kguiaddons-${PVCUT}*:5
	=kde-frameworks/ki18n-${PVCUT}*:5
	=kde-frameworks/kiconthemes-${PVCUT}*:5
	=kde-frameworks/kio-${PVCUT}*:5
	=kde-frameworks/kirigami-${PVCUT}*:5
	=kde-frameworks/knotifications-${PVCUT}*:5
	=kde-frameworks/kpackage-${PVCUT}*:5
	=kde-frameworks/kservice-${PVCUT}*:5
	=kde-frameworks/kwidgetsaddons-${PVCUT}*:5
	=kde-frameworks/kwindowsystem-${PVCUT}*:5
	=kde-frameworks/kxmlgui-${PVCUT}*:5
	!gles2? ( virtual/opengl )
	wayland? (
		=kde-frameworks/kwayland-${PVCUT}*:5
		media-libs/mesa[egl]
	)
	X? (
		>=dev-qt/qtx11extras-${QTMIN}:5
		x11-libs/libX11
		x11-libs/libxcb
	)
"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )
"

RESTRICT+=" test"

PATCHES=(
	"${FILESDIR}/${P}-construct-nullengine-w-KPluginMetadata.patch" # KDE-Bug #417548
	"${FILESDIR}/${P}-remove-hardcoded-colors.patch" # KDE-Bug #417511
)

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package !gles2 OpenGL)
		$(cmake_use_find_package wayland EGL)
		$(cmake_use_find_package wayland KF5Wayland)
		$(cmake_use_find_package X X11)
		$(cmake_use_find_package X XCB)
	)

	ecm_src_configure
}

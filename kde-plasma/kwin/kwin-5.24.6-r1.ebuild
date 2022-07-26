# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="optional"
KFMIN=5.92.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.15.4
VIRTUALX_REQUIRED="test"
inherit ecm plasma.kde.org optfeature

DESCRIPTION="Flexible, composited Window Manager for windowing systems on Linux"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="accessibility caps gles2-only multimedia plasma screencast"

RESTRICT="test"

COMMON_DEPEND="
	>=dev-libs/libinput-1.19
	>=dev-libs/wayland-1.2
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5=[gles2-only=,libinput]
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	>=kde-frameworks/kactivities-${KFMIN}:5
	>=kde-frameworks/kauth-${KFMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/kglobalaccel-${KFMIN}:5=
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kidletime-${KFMIN}:5=
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kpackage-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwayland-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5=[X]
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/plasma-${KFMIN}:5
	>=kde-plasma/breeze-${PVCUT}:5
	>=kde-plasma/kdecoration-${PVCUT}:5
	>=kde-plasma/kscreenlocker-${PVCUT}:5
	>=kde-plasma/kwayland-server-${PVCUT}:5
	media-libs/fontconfig
	media-libs/freetype
	media-libs/lcms:2
	media-libs/libepoxy
	>=media-libs/mesa-21.1[egl(+),gbm(+),wayland,X]
	virtual/libudev:=
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libdrm
	>=x11-libs/libxcb-1.10
	>=x11-libs/libxkbcommon-0.7.0
	x11-libs/xcb-util-cursor
	x11-libs/xcb-util-image
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-wm
	accessibility? ( media-libs/libqaccessibilityclient:5 )
	caps? ( sys-libs/libcap )
	gles2-only? ( media-libs/mesa[gles2] )
	plasma? ( >=kde-frameworks/krunner-${KFMIN}:5 )
	screencast? ( >=media-video/pipewire-0.3:= )
"
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qtquickcontrols-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=dev-qt/qtvirtualkeyboard-${QTMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5[qml]
	sys-apps/hwdata
	x11-base/xwayland
	multimedia? ( >=dev-qt/qtmultimedia-${QTMIN}:5[gstreamer,qml] )
"
DEPEND="${COMMON_DEPEND}
	>=dev-qt/designer-${QTMIN}:5
	>=dev-qt/qtconcurrent-${QTMIN}:5
	x11-base/xorg-proto
	test? (
		dev-libs/plasma-wayland-protocols
		>=dev-libs/wayland-protocols-1.19
	)
"
BDEPEND="test? ( >=dev-qt/qtwaylandscanner-${QTMIN}:5 )"
PDEPEND=">=kde-plasma/kde-cli-tools-${PVCUT}:5"

PATCHES=(
	"${FILESDIR}/${P}-emit-rowsChanged.patch"
	"${FILESDIR}/${P}-fix-color-picker.patch" # KDE-bug 454974
)

src_prepare() {
	ecm_src_prepare
	use multimedia || eapply "${FILESDIR}/${PN}-5.21.80-gstreamer-optional.patch"

	# TODO: try to get a build switch upstreamed
	if ! use screencast; then
		sed -e "s/^pkg_check_modules.*PipeWire/#&/" -i CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package accessibility QAccessibilityClient)
		$(cmake_use_find_package caps Libcap)
		$(cmake_use_find_package plasma KF5Runner)
	)

	ecm_src_configure
}

pkg_postinst() {
	ecm_pkg_postinst
	optfeature "color management support" x11-misc/colord
	elog
	elog "In Plasma 5.20, default behavior of the Task Switcher to move minimised"
	elog "windows to the end of the list was changed so that it remains in the"
	elog "original order. To revert to the well established behavior:"
	elog
	elog " - Edit ~/.config/kwinrc"
	elog " - Find [TabBox] section"
	elog " - Add \"MoveMinimizedWindowsToEndOfTabBoxFocusChain=true\""
}

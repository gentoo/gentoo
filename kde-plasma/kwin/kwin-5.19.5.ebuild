# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="optional"
ECM_TEST="optional"
KFMIN=5.71.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.14.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Flexible, composited Window Manager for windowing systems on Linux"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="caps gles2-only multimedia"

COMMON_DEPEND="
	>=dev-libs/libinput-1.14
	>=dev-libs/wayland-1.2
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5=[gles2-only=]
	>=dev-qt/qtscript-${QTMIN}:5
	>=dev-qt/qtsensors-${QTMIN}:5
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
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/kglobalaccel-${KFMIN}:5=
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kidletime-${KFMIN}:5=
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kpackage-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwayland-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5[X]
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/plasma-${KFMIN}:5
	>=kde-plasma/breeze-${PVCUT}:5
	>=kde-plasma/kdecoration-${PVCUT}:5
	>=kde-plasma/kscreenlocker-${PVCUT}:5
	>=kde-plasma/kwayland-server-${PVCUT}:5
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libepoxy
	media-libs/mesa[egl,gbm,wayland,X(+)]
	virtual/libudev:=
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libdrm
	>=x11-libs/libxcb-1.10
	>=x11-libs/libxkbcommon-0.7.0
	x11-libs/xcb-util-cursor
	x11-libs/xcb-util-image
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-wm
	caps? ( sys-libs/libcap )
	gles2-only? ( media-libs/mesa[gles2] )
"
# TODO: sys-apps/hwdata? not packaged yet; commit 33a1777a, Gentoo-bug 717216
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qtquickcontrols-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=dev-qt/qtvirtualkeyboard-${QTMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5[qml]
	multimedia? ( >=dev-qt/qtmultimedia-${QTMIN}:5[gstreamer,qml] )
"
DEPEND="${COMMON_DEPEND}
	>=dev-qt/designer-${QTMIN}:5
	>=dev-qt/qtconcurrent-${QTMIN}:5
	x11-base/xorg-proto
"
PDEPEND="
	>=kde-plasma/kde-cli-tools-${PVCUT}:5
"

RESTRICT+=" test"

src_prepare() {
	ecm_src_prepare
	use multimedia || eapply "${FILESDIR}/${PN}-5.16.80-gstreamer-optional.patch"
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package caps Libcap)
	)

	ecm_src_configure
}

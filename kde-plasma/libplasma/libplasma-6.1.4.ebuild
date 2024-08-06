# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_NONGUI="true"
ECM_QTHELP="true"
ECM_TEST="true"
KFMIN=6.3.0
PVCUT=$(ver_cut 1-3)
QTMIN=6.7.1
inherit ecm plasma.kde.org

DESCRIPTION="Plasma library and runtime components based upon KF6 and Qt6"

LICENSE="LGPL-2+"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="gles2-only"

RESTRICT="test"

# kde-frameworks/kwindowsystem[X]: Unconditional use of KX11Extras
COMMON_DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6=[dbus,gles2-only=,gui,widgets,X]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
	>=dev-libs/wayland-1.15.0
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6[qml]
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kglobalaccel-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kpackage-${KFMIN}:6
	>=kde-frameworks/ksvg-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6[X]
	=kde-plasma/plasma-activities-${PVCUT}*:6
	media-libs/libglvnd
	x11-libs/libX11
	x11-libs/libxcb
	!gles2-only? ( media-libs/libglvnd[X] )
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/plasma-wayland-protocols-1.13.0
	x11-base/xorg-proto
"
RDEPEND="${COMMON_DEPEND}
	!${CATEGORY}/${PN}:5[-kf6compat(-)]
"
BDEPEND="
	>=dev-qt/qtwayland-${QTMIN}:6
	>=dev-util/wayland-scanner-1.19.0
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package !gles2-only OpenGL)
	)

	ecm_src_configure
}

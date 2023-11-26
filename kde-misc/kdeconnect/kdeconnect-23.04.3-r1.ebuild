# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="true"
KDE_ORG_NAME="${PN}-kde"
KDE_SELINUX_MODULE="${PN}"
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm gear.kde.org

DESCRIPTION="Adds communication between KDE Plasma and your smartphone"
HOMEPAGE="https://kdeconnect.kde.org/ https://apps.kde.org/kdeconnect/"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="amd64 arm64 ~ppc64 x86"
IUSE="bluetooth pulseaudio telephony X"

RESTRICT="test"

COMMON_DEPEND="
	>=app-crypt/qca-2.3.0:2[qt5(+),ssl]
	>=dev-libs/wayland-1.15.0
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5=
	>=dev-qt/qtmultimedia-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=dev-qt/qtwayland-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kpeople-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-plasma/libplasma-${KFMIN}:5
	>=kde-frameworks/qqc2-desktop-style-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
	x11-libs/libxkbcommon
	bluetooth? ( >=dev-qt/qtbluetooth-${QTMIN}:5 )
	pulseaudio? ( media-libs/pulseaudio-qt:= )
	telephony? ( >=kde-frameworks/modemmanager-qt-${KFMIN}:5 )
	X? (
		x11-libs/libfakekey
		x11-libs/libX11
		x11-libs/libXtst
	)
"
DEPEND="${COMMON_DEPEND}
	dev-libs/wayland-protocols
"
RDEPEND="${COMMON_DEPEND}
	dev-libs/kirigami-addons:5
	dev-libs/kpeoplevcard
	>=dev-qt/qtgraphicaleffects-${QTMIN}:5
	>=dev-qt/qtmultimedia-${QTMIN}:5[qml]
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	net-fs/sshfs
"
BDEPEND="
	>=dev-qt/qtwaylandscanner-${QTMIN}:5
	dev-util/wayland-scanner
"

PATCHES=(
	"${FILESDIR}/${PN}-21.07.80-revert-disable-kpeople.patch"
	"${FILESDIR}/${PN}-23.04.0-telephony-optional.patch" # bug 904823
)

src_configure() {
	local mycmakeargs=(
		-DBLUETOOTH_ENABLED=$(usex bluetooth)
		$(cmake_use_find_package pulseaudio KF5PulseAudioQt)
		$(cmake_use_find_package telephony KF5ModemManagerQt)
		$(cmake_use_find_package X LibFakeKey)
	)
	ecm_src_configure
}

pkg_postinst() {
	ecm_pkg_postinst

	elog "The Android .apk file is available via"
	elog "https://play.google.com/store/apps/details?id=org.kde.kdeconnect_tp"
	elog "or via"
	elog "https://f-droid.org/packages/org.kde.kdeconnect_tp/"
}

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_TEST="true"
KDE_ORG_NAME="${PN}-kde"
KDE_SELINUX_MODULE="${PN}"
KFMIN=6.3.0
QTMIN=6.6.2
inherit ecm flag-o-matic gear.kde.org

DESCRIPTION="Adds communication between KDE Plasma and your smartphone"
HOMEPAGE="https://kdeconnect.kde.org/ https://apps.kde.org/kdeconnect/"

LICENSE="GPL-2+"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="bluetooth pulseaudio telephony zeroconf X"

RESTRICT="test"

# slot op: Uses Qt6::GuiPrivate for qtx11extras_p.h
# TODO: make conditional on X upstream
COMMON_DEPEND="
	dev-libs/openssl:=
	>=dev-libs/wayland-1.15.0
	>=dev-qt/qtbase-${QTMIN}:6=[dbus,gui,network,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtmultimedia-${QTMIN}:6
	>=dev-qt/qtwayland-${QTMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kpeople-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kstatusnotifieritem-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/qqc2-desktop-style-${KFMIN}:6
	>=kde-frameworks/solid-${KFMIN}:6
	sys-apps/dbus
	x11-libs/libxkbcommon
	bluetooth? ( >=dev-qt/qtconnectivity-${QTMIN}:6[bluetooth] )
	pulseaudio? ( >=media-libs/pulseaudio-qt-1.4:= )
	telephony? ( >=kde-frameworks/modemmanager-qt-${KFMIN}:6 )
	zeroconf? ( >=kde-frameworks/kdnssd-${KFMIN}:6 )
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
	dev-libs/kirigami-addons:6
	>=dev-qt/qt5compat-${QTMIN}:6[qml]
	>=dev-qt/qtmultimedia-${QTMIN}:6[qml]
	|| (
		>=dev-qt/qttools-${QTMIN}:6[qdbus]
		dev-qt/qdbus:*
	)
	>=kde-frameworks/kdeclarative-${KFMIN}:6
	kde-plasma/libplasma:6
	net-fs/sshfs
"
BDEPEND="
	>=dev-qt/qtwayland-${QTMIN}:6
	dev-util/wayland-scanner
	virtual/pkgconfig
"

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/921648
	# https://bugs.kde.org/show_bug.cgi?id=480522
	filter-lto

	local mycmakeargs=(
		-DMDNS_ENABLED=$(usex zeroconf)
		-DBLUETOOTH_ENABLED=$(usex bluetooth)
		-DWITH_PULSEAUDIO=$(usex pulseaudio)
		$(cmake_use_find_package telephony KF6ModemManagerQt)
		-DWITH_X11=$(usex X)
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

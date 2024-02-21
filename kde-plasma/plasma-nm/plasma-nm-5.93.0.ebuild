# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KFMIN=5.249.0
PVCUT=$(ver_cut 1-3)
QTMIN=6.6.2
inherit ecm plasma.kde.org

DESCRIPTION="KDE Plasma applet for NetworkManager"

LICENSE="GPL-2 LGPL-2.1"
SLOT="6"
KEYWORDS="~amd64"
IUSE="openconnect teamd"

DEPEND="
	>=app-crypt/qca-2.3.7:2[qt6]
	dev-libs/qcoro[dbus]
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,widgets,xml]
	>=dev-qt/qtdeclarative-${QTMIN}:6[widgets]
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/ksvg-${KFMIN}:6
	>=kde-frameworks/kwallet-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/modemmanager-qt-${KFMIN}:6
	>=kde-frameworks/networkmanager-qt-${KFMIN}:6[teamd=]
	>=kde-frameworks/solid-${KFMIN}:6
	>=kde-plasma/libplasma-${PVCUT}:6
	net-misc/mobile-broadband-provider-info
	net-misc/networkmanager[teamd=]
	openconnect? (
		>=dev-qt/qtwebengine-${QTMIN}:6
		net-vpn/networkmanager-openconnect
		net-vpn/openconnect:=
	)
"
RDEPEND="${DEPEND}
	>=kde-frameworks/kdeclarative-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/kquickcharts-${KFMIN}:6
	>=kde-plasma/kde-cli-tools-${PVCUT}:*
"
BDEPEND="
	>=kde-frameworks/kcmutils-${KFMIN}:6
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_OPENCONNECT=$(usex openconnect)
	)

	ecm_src_configure
}

pkg_postinst() {
	ecm_pkg_postinst

	if ! has_version "kde-frameworks/kcmutils:6"; then
		elog "${PN} is not terribly useful without kde-frameworks/kcmutils:6."
		elog "However, the networkmanagement KCM can be called from either systemsettings"
		elog "or manually: $ kcmshell6 kcm_networkmanagement"
	fi
}

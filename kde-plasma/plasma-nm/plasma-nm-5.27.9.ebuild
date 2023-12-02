# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KFMIN=5.106.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.15.9
inherit ecm plasma.kde.org

DESCRIPTION="KDE Plasma applet for NetworkManager"

LICENSE="GPL-2 LGPL-2.1"
SLOT="5"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE="openconnect teamd"

DEPEND="
	>=app-crypt/qca-2.3.0:2[qt5(+)]
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5[widgets]
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/modemmanager-qt-${KFMIN}:5
	>=kde-frameworks/networkmanager-qt-${KFMIN}:5[teamd=]
	>=kde-plasma/libplasma-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
	net-misc/mobile-broadband-provider-info
	net-misc/networkmanager[teamd=]
	openconnect? (
		net-vpn/networkmanager-openconnect
		net-vpn/openconnect:=
	)
"
RDEPEND="${DEPEND}
	>=dev-qt/qtquickcontrols-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	>=kde-frameworks/kquickcharts-${KFMIN}:5
	>=kde-plasma/kde-cli-tools-${PVCUT}:5
"
BDEPEND="
	>=kde-frameworks/kcmutils-${KFMIN}:5
	virtual/pkgconfig
"

src_prepare() {
	ecm_src_prepare

	# TODO: try to get a build switch upstreamed
	if ! use openconnect; then
		sed -e "s/^pkg_check_modules.*openconnect/#&/" -i CMakeLists.txt || die
	fi
}

pkg_postinst() {
	ecm_pkg_postinst

	if ! has_version "kde-plasma/plasma-workspace:5"; then
		elog "${PN} is not terribly useful without kde-plasma/plasma-workspace:5."
		elog "However, the networkmanagement KCM can be called from either systemsettings"
		elog "or manually: $ kcmshell5 kcm_networkmanagement"
	fi
}

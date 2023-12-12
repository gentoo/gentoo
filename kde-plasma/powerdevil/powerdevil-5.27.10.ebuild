# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
KFMIN=5.106.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.15.9
inherit ecm plasma.kde.org

DESCRIPTION="Power management for KDE Plasma Shell"
HOMEPAGE="https://invent.kde.org/plasma/powerdevil"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="brightness-control caps +wireless"

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	>=kde-frameworks/kauth-${KFMIN}:5[policykit]
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kglobalaccel-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kidletime-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/knotifyconfig-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
	>=kde-plasma/libkscreen-${PVCUT}:5
	>=kde-plasma/libkworkspace-${PVCUT}:5
	>=kde-plasma/plasma-activities-${KFMIN}:5
	virtual/libudev:=
	x11-libs/libxcb
	brightness-control? ( app-misc/ddcutil:= )
	caps? ( sys-libs/libcap )
	wireless? (
		>=kde-frameworks/bluez-qt-${KFMIN}:5
		>=kde-frameworks/networkmanager-qt-${KFMIN}:5
	)
"
RDEPEND="${DEPEND}
	>=kde-plasma/kde-cli-tools-${PVCUT}:*
	sys-power/power-profiles-daemon
	>=sys-power/upower-0.9.23
"
BDEPEND=">=kde-frameworks/kcmutils-${KFMIN}:5"

src_configure() {
	local mycmakeargs=(
		-DHAVE_DDCUTIL=$(usex brightness-control)
		$(cmake_use_find_package caps Libcap)
		$(cmake_use_find_package wireless KF5BluezQt)
		$(cmake_use_find_package wireless KF5NetworkManagerQt)
	)

	ecm_src_configure
}

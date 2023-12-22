# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.247.0
PVCUT=$(ver_cut 1-3)
QTMIN=6.6.0
inherit ecm plasma.kde.org

DESCRIPTION="Plasma applet and services for creating encrypted vaults"
HOMEPAGE+=" https://cukic.co/2017/02/03/vaults-encryption-in-plasma/"

LICENSE="LGPL-3"
SLOT="6"
KEYWORDS="~amd64"
IUSE="networkmanager"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-plasma/libksysguard-${PVCUT}:6
	>=kde-plasma/libplasma-${PVCUT}:6
	>=kde-plasma/plasma-activities-${PVCUT}:6
	networkmanager? ( >=kde-frameworks/networkmanager-qt-${KFMIN}:6 )
"
RDEPEND="${DEPEND}
	|| ( >=sys-fs/cryfs-0.9.9 >=sys-fs/encfs-1.9.2 )
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package networkmanager KF6NetworkManagerQt)
	)

	ecm_src_configure
}

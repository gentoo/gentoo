# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.102.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.15.7
inherit ecm plasma.kde.org

DESCRIPTION="Plasma applet and services for creating encrypted vaults"
HOMEPAGE+=" https://cukic.co/2017/02/03/vaults-encryption-in-plasma/"

LICENSE="LGPL-3"
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="networkmanager"

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kactivities-${KFMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/plasma-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-plasma/libksysguard-${PVCUT}:5
	networkmanager? ( >=kde-frameworks/networkmanager-qt-${KFMIN}:5 )
"
RDEPEND="${DEPEND}
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	|| ( >=sys-fs/cryfs-0.9.9 >=sys-fs/encfs-1.9.2 )
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package networkmanager KF5NetworkManagerQt)
	)

	ecm_src_configure
}

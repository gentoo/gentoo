# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_EXAMPLES="true"
ECM_TEST="true"
KFMIN=6.3.0
PVCUT=$(ver_cut 1-3)
QTMIN=6.7.1
inherit ecm plasma.kde.org

DESCRIPTION="Library and examples for creating an RDP server"
HOMEPAGE+=" https://quantumproductions.info/articles/2023-08/remote-desktop-using-rdp-protocol-plasma-wayland"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE=""

COMMON_DEPEND="
	>=dev-libs/qtkeychain-0.14.1-r1:=[qt6]
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtwayland-${QTMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kstatusnotifieritem-${KFMIN}:6
	>=kde-plasma/kpipewire-${PVCUT}:6
	>=net-misc/freerdp-2.10:2[server]
	x11-libs/libxkbcommon
"
DEPEND="${COMMON_DEPEND}
	dev-libs/plasma-wayland-protocols
"
RDEPEND="${COMMON_DEPEND}
	>=kde-frameworks/kirigami-${KFMIN}:6
"
BDEPEND=">=kde-frameworks/kcmutils-${KFMIN}:6"

PATCHES=( "${FILESDIR}/${PN}-6.0.90-cmake.patch" ) # fixed in 6.1.1

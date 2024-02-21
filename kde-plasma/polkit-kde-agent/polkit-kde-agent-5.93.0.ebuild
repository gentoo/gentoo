# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_NAME="${PN}-1"
KFMIN=5.249.0
PVCUT=$(ver_cut 1-3)
QTMIN=6.6.2
inherit ecm plasma.kde.org

DESCRIPTION="PolKit agent module for KDE Plasma"
HOMEPAGE="https://kde.org/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6[X]
	>=sys-auth/polkit-qt-0.175[qt6]
"
RDEPEND="${DEPEND}
	>=dev-qt/qt5compat-${QTMIN}:6[qml]
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-plasma/libplasma-${PVCUT}:6
"

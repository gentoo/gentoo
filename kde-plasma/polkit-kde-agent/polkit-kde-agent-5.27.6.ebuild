# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_NAME="${PN}-1"
KFMIN=5.106.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.15.9
inherit ecm plasma.kde.org

DESCRIPTION="PolKit agent module for KDE Plasma"
HOMEPAGE="https://kde.org/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5[X]
	>=sys-auth/polkit-qt-0.113.0[qt5(+)]
"
RDEPEND="${DEPEND}"

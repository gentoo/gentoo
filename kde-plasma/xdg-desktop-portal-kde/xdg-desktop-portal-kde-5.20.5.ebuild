# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KFMIN=5.74.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.15.1
inherit ecm kde.org

DESCRIPTION="Backend implementation for xdg-desktop-portal that is using Qt/KDE Frameworks"

LICENSE="LGPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE=""

COMMON_DEPEND="
	>=dev-libs/wayland-1.15
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5[cups]
	>=dev-qt/qtwayland-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/plasma-${KFMIN}:5
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/plasma-wayland-protocols-1.1.1
	>=dev-qt/qtconcurrent-${QTMIN}:5
	>=kde-frameworks/kwayland-${KFMIN}:5
"
RDEPEND="${COMMON_DEPEND}
	sys-apps/xdg-desktop-portal
"

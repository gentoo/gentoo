# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_NONGUI="true"
KFMIN=6.0.0
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="Library for managing partitions"
HOMEPAGE="https://apps.kde.org/partitionmanager/"

LICENSE="GPL-3"
SLOT="6/10"
KEYWORDS="~amd64"
IUSE=""

# bug 689468, tests need polkit etc.
RESTRICT="test"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=sys-apps/util-linux-2.33.2
	>=sys-auth/polkit-qt-0.175.0[qt6]
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

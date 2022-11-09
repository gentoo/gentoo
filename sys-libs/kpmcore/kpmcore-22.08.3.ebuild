# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_NONGUI="true"
KFMIN=5.96.0
QTMIN=5.15.5
inherit ecm gear.kde.org

DESCRIPTION="Library for managing partitions"
HOMEPAGE="https://apps.kde.org/partitionmanager/"

LICENSE="GPL-3"
SLOT="5/10"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~x86"
IUSE=""

# bug 689468, tests need polkit etc.
RESTRICT="test"

BDEPEND="virtual/pkgconfig"
DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=sys-apps/util-linux-2.33.2
	>=sys-auth/polkit-qt-0.113.0[qt5(+)]
"
RDEPEND="${DEPEND}"

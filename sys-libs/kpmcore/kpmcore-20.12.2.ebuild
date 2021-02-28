# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_NONGUI="true"
KDE_RELEASE_SERVICE="true"
KFMIN=5.74.0
QTMIN=5.15.2
inherit ecm kde.org

DESCRIPTION="Library for managing partitions"
HOMEPAGE="https://apps.kde.org/en/partitionmanager"

LICENSE="GPL-3"
SLOT="5/10"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE=""

BDEPEND="virtual/pkgconfig"
DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=sys-apps/util-linux-2.33.2
	sys-auth/polkit-qt
"
RDEPEND="${DEPEND}"

# bug 689468, tests need polkit etc.
RESTRICT+=" test"

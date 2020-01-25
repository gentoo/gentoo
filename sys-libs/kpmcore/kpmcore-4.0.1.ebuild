# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

DESCRIPTION="Library for managing partitions"
HOMEPAGE="https://kde.org/applications/system/org.kde.partitionmanager"

LICENSE="GPL-3"
SLOT="5/8"
IUSE=""

BDEPEND="virtual/pkgconfig"
DEPEND="
	|| (
		app-crypt/qca[botan]
		app-crypt/qca[ssl]
	)
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kauth-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=sys-apps/util-linux-2.33.2
"
RDEPEND="${DEPEND}"

# bug 689468, tests need polkit etc.
RESTRICT+=" test"

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kde5

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
	$(add_frameworks_dep kauth)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	|| (
		app-crypt/qca[botan]
		app-crypt/qca[ssl]
	)
	>=sys-apps/util-linux-2.33.2
"
RDEPEND="${DEPEND}"

# bug 689468, tests need polkit etc.
RESTRICT+=" test"

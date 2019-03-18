# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT="317b1e70a87224c94cac85955a3d666a43527812"
KDE_HANDBOOK="optional"
inherit kde5

DESCRIPTION="The japanese warehouse keeper game"
HOMEPAGE="https://cgit.kde.org/ksokoban.git"
SRC_URI="https://github.com/KDE/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
"
DEPEND="${RDEPEND}
	$(add_frameworks_dep kiconthemes)
"

S="${WORKDIR}/${PN}-${COMMIT}"

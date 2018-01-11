# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_BLOCK_SLOT4="false"
inherit kde5

DESCRIPTION="Mahjongg library based on Qt/KDE Frameworks"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
"
RDEPEND="${DEPEND}"

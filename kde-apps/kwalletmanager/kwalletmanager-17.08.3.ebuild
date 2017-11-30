# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_BLOCK_SLOT4="false"
KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="KDE Wallet management tool"
HOMEAGE="https://www.kde.org/applications/system/kwalletmanager
https://utils.kde.org/projects/kwalletmanager"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kauth)
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwallet)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
"
RDEPEND="${DEPEND}
	!<kde-apps/kwalletmanager-15.04.3-r1:4
	!kde-base/legacy-icons
"

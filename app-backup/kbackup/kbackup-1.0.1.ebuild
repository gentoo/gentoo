# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="Program that lets you back up any directories or files"
HOMEPAGE="https://www.linux-apps.com/content/show.php/KBackup?content=44998"
[[ ${KDE_BUILD_TYPE} = release ]] && SRC_URI="http://members.aon.at/m.koller/${P}.tar.xz"

LICENSE="GPL-2"
KEYWORDS="~amd64 x86"
IUSE=""

CDEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
"
DEPEND="${CDEPEND}
	x11-misc/shared-mime-info
"
RDEPEND="${CDEPEND}
	!app-backup/kbackup:4
"

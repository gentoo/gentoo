# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="Assistant to import PIM data from other applications into Akonadi"
HOMEPAGE+=" https://userbase.kde.org/Kmail/Import_Options"
LICENSE="GPL-2+ handbook? ( FDL-1.2+ )"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kwallet)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_kdeapps_dep akonadi)
	$(add_kdeapps_dep kcontacts)
	$(add_kdeapps_dep kidentitymanagement)
	$(add_kdeapps_dep kmailtransport)
	$(add_kdeapps_dep libkdepim)
	$(add_kdeapps_dep mailcommon)
	$(add_kdeapps_dep mailimporter)
	$(add_kdeapps_dep messagelib)
	$(add_kdeapps_dep pimcommon)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
"
RDEPEND="${DEPEND}
	!kde-apps/kmail:4
"

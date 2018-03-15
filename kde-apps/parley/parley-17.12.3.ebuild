# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
KDE_DOC_DIR="docs"
inherit kde5

DESCRIPTION="A vocabulary trainer to help you memorize things"
HOMEPAGE="https://www.kde.org/applications/education/parley
https://edu.kde.org/applications/school/parley"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	$(add_kdeapps_dep libkeduvocdocument)
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep khtml)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kross)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep sonnet)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtconcurrent)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtmultimedia)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtwebengine 'widgets')
	dev-libs/libxml2:2
	dev-libs/libxslt
"
RDEPEND="${DEPEND}
	$(add_kdeapps_dep kdeedu-data)
"

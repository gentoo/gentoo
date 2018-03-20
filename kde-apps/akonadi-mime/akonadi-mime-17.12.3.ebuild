# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_TEST="true"
inherit kde5

DESCRIPTION="Library for akonadi mime types"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2+ LGPL-2.1+"
IUSE=""

# some akonadi tests time out, that probably needs more work as it's ~700 tests
RESTRICT+=" test"

DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemmodels)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_kdeapps_dep akonadi)
	$(add_kdeapps_dep kmime)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	dev-libs/libxslt
	x11-misc/shared-mime-info
"
RDEPEND="${DEPEND}
	!kde-apps/kdepim-l10n
	!kde-apps/kdepimlibs:4
"

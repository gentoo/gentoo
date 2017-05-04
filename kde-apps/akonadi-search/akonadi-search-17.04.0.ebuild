# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5

DESCRIPTION="Libraries and daemons to implement searching in Akonadi"
HOMEPAGE="https://projects.kde.org/projects/playground/pim/akonadi-search"
LICENSE="GPL-2+ LGPL-2.1+"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep krunner)
	$(add_kdeapps_dep akonadi)
	$(add_kdeapps_dep akonadi-mime)
	$(add_kdeapps_dep kcalcore)
	$(add_kdeapps_dep kcontacts)
	$(add_kdeapps_dep kmime)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	>=dev-libs/xapian-1.3:=[chert]
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
"
RDEPEND="${COMMON_DEPEND}
	!kde-apps/kdepim-l10n
"

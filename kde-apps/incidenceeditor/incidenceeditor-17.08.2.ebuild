# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Incidence editor for korganizer"
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemmodels)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_kdeapps_dep akonadi)
	$(add_kdeapps_dep akonadi-calendar)
	$(add_kdeapps_dep akonadi-contacts)
	$(add_kdeapps_dep akonadi-mime)
	$(add_kdeapps_dep calendarsupport)
	$(add_kdeapps_dep eventviews)
	$(add_kdeapps_dep kcalcore)
	$(add_kdeapps_dep kcalutils)
	$(add_kdeapps_dep kcontacts)
	$(add_kdeapps_dep kdepim-apps-libs)
	$(add_kdeapps_dep kidentitymanagement)
	$(add_kdeapps_dep kldap)
	$(add_kdeapps_dep kmailtransport)
	$(add_kdeapps_dep kmime)
	$(add_kdeapps_dep libkdepim)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	dev-libs/kdiagram:5
"
RDEPEND="${DEPEND}
	!kde-apps/kdepim-common-libs:4
	!kde-apps/kdepim-l10n
"

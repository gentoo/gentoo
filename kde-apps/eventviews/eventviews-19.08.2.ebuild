# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="true"
inherit kde5

DESCRIPTION="Calendar viewer for KDE PIM"
LICENSE="GPL-2+ LGPL-2.1+"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

# drop qtgui subslot operator when QT_MINIMAL >= 5.14.0
DEPEND="
	$(add_frameworks_dep kcalendarcore)
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcontacts)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kitemmodels)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_kdeapps_dep akonadi)
	$(add_kdeapps_dep akonadi-calendar)
	$(add_kdeapps_dep calendarsupport)
	$(add_kdeapps_dep kcalutils)
	$(add_kdeapps_dep kmime)
	$(add_kdeapps_dep libkdepim)
	$(add_qt_dep designer)
	$(add_qt_dep qtgui '' '' '5=')
	$(add_qt_dep qtwidgets)
	dev-libs/kdiagram:5
	dev-libs/libical
"
RDEPEND="${DEPEND}
	!kde-apps/kdepim-l10n
"

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
KDE_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Runtime plugin collection to extend the functionality of KDE PIM"
LICENSE="GPL-2+ LGPL-2.1+"
KEYWORDS="~amd64 ~x86"
IUSE="speech"

# TODO kolab
CDEPEND="
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemmodels)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwallet)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_kdeapps_dep akonadi)
	$(add_kdeapps_dep akonadi-calendar)
	$(add_kdeapps_dep akonadi-contacts)
	$(add_kdeapps_dep akonadi-mime)
	$(add_kdeapps_dep akonadi-notes)
	$(add_kdeapps_dep kalarmcal)
	$(add_kdeapps_dep kcalcore)
	$(add_kdeapps_dep kcalutils)
	$(add_kdeapps_dep kcontacts)
	$(add_kdeapps_dep kdav)
	$(add_kdeapps_dep kidentitymanagement)
	$(add_kdeapps_dep kimap)
	$(add_kdeapps_dep kmailtransport)
	$(add_kdeapps_dep kmbox)
	$(add_kdeapps_dep kmime)
	$(add_kdeapps_dep libkgapi)
	$(add_kdeapps_dep pimcommon)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwebengine 'widgets')
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	dev-libs/cyrus-sasl:2
	dev-libs/libical:=
	speech? ( $(add_qt_dep qtspeech) )
"
DEPEND="${CDEPEND}
	$(add_qt_dep qtxmlpatterns)
	dev-libs/libxslt
	test? ( $(add_kdeapps_dep kimap 'test') )
"
RDEPEND="${CDEPEND}
	!kde-apps/kdepim-l10n
	!kde-misc/akonadi-ews
	$(add_frameworks_dep oxygen-icons)
"

RESTRICT+=" test"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package speech Qt5TextToSpeech)
	)

	kde5_src_configure
}

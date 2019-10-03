# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="forceoptional"
KDE_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Runtime plugin collection to extend the functionality of KDE PIM"
LICENSE="GPL-2+ LGPL-2.1+"
KEYWORDS="amd64 arm64 x86"
IUSE=""

# TODO kolab
BDEPEND="
	dev-libs/libxslt
"
COMMON_DEPEND="
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kholidays)
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
	$(add_qt_dep qtnetworkauth)
	$(add_qt_dep qtspeech)
	$(add_qt_dep qtwebengine 'widgets')
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	dev-libs/cyrus-sasl:2
	dev-libs/libical:=
"
DEPEND="${COMMON_DEPEND}
	$(add_qt_dep qtxmlpatterns)
	test? ( $(add_kdeapps_dep kimap 'test') )
"
RDEPEND="${COMMON_DEPEND}
	!kde-apps/kdepim-l10n
	!kde-misc/akonadi-ews
"

PATCHES=(
	"${FILESDIR}/${P}-ui_lockfilepage-race-condition.patch"
	"${FILESDIR}/${P}-ui_compactpage-race-condition.patch"
)

RESTRICT+=" test"

src_prepare() {
	kde5_src_prepare
	# We don't build kolab, so we can disable this
	punt_bogus_dep KF5 KDELibs4Support
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Libkolabxml=ON
	)
	kde5_src_configure
}

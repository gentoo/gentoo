# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_APPS_MINIMAL="19.08.0"
KDE_HANDBOOK="forceoptional"
KDE_TEST="forceoptional"
inherit kde5

DESCRIPTION="Project management application"
HOMEPAGE="https://www.calligra.org/"
SRC_URI="mirror://kde/stable/${PN/plan/}/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="activities +holidays kwallet pim X"

# FIXME: Disabled by upstream for good reason
# Crashes (https://bugs.kde.org/show_bug.cgi?id=311940)
# $(add_kdeapps_dep akonadi)
# $(add_kdeapps_dep akonadi-contacts)
# Currently upstream-disabled:
# =dev-libs/kproperty-3.0*:5
# =dev-libs/kreport-3.0*:5
DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kglobalaccel)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep khtml)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep designer)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	dev-lang/perl
	dev-libs/kdiagram:5
	sys-libs/zlib
	activities? ( $(add_frameworks_dep kactivities) )
	holidays? ( $(add_frameworks_dep kholidays) )
	kwallet? (
		$(add_frameworks_dep kwallet)
		app-crypt/qca:2[qt5(+)]
	)
	pim? (
		|| (
			$(add_frameworks_dep kcalendarcore)
			$(add_kdeapps_dep kcalcore)
		)
		|| (
			$(add_frameworks_dep kcontacts)
			$(add_kdeapps_dep kcontacts)
		)
	)
	X? (
		$(add_qt_dep qtx11extras)
		x11-libs/libX11
	)
"
RDEPEND="${DEPEND}
	!app-office/calligra[calligra_features_plan(-)]
	!app-office/calligra-l10n:4
	$(add_qt_dep qtsvg)
"

RESTRICT+=" test"

PATCHES=(
	"${FILESDIR}"/${P}-qt-5.11.patch
	"${FILESDIR}"/${P}-qca.patch
	"${FILESDIR}"/${P}-missing-header.patch
	"${FILESDIR}"/${P}-unused-deps.patch
	"${FILESDIR}"/${P}-kcalcore-19.08-{1,2,3}.patch
)

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package activities KF5Activities)
		$(cmake-utils_use_find_package holidays KF5Holidays)
		$(cmake-utils_use_find_package pim KF5CalendarCore)
		$(cmake-utils_use_find_package pim KF5Contacts)
		$(cmake-utils_use_find_package kwallet Qca-qt5)
		$(cmake-utils_use_find_package kwallet KF5Wallet)
	)
	# Qt5DBus can't be disabled because of KF5DBusAddons dependency

	kde5_src_configure
}

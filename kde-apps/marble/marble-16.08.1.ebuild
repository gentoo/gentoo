# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="forceoptional"
KDE_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Virtual Globe and World Atlas to learn more about Earth"
HOMEPAGE="https://marble.kde.org/"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"

IUSE="aprs +dbus designer gps +kde phonon +positioning shapefile"

# FIXME (new package): libwlocate, WLAN-based geolocation
RDEPEND="
	$(add_qt_dep qtconcurrent)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtscript)
	$(add_qt_dep qtsql)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwebkit)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	aprs? ( $(add_qt_dep qtserialport) )
	dbus? ( $(add_qt_dep qtdbus) )
	designer? ( $(add_qt_dep designer) )
	gps? ( sci-geosciences/gpsd )
	kde? (
		$(add_frameworks_dep kconfig)
		$(add_frameworks_dep kconfigwidgets)
		$(add_frameworks_dep kcoreaddons)
		$(add_frameworks_dep kcrash)
		$(add_frameworks_dep ki18n)
		$(add_frameworks_dep kio)
		$(add_frameworks_dep knewstuff)
		$(add_frameworks_dep kparts)
		$(add_frameworks_dep krunner)
		$(add_frameworks_dep kservice)
		$(add_frameworks_dep kwallet)
	)
	phonon? ( media-libs/phonon[qt5] )
	positioning? (
		$(add_qt_dep qtlocation)
		$(add_qt_dep qtpositioning)
	)
	shapefile? ( sci-libs/shapelib )
"
DEPEND="${RDEPEND}
	aprs? ( dev-lang/perl )
"

# bug 588320
RESTRICT=test

src_prepare() {
	if use kde; then
		sed -e "/add_subdirectory(marble-qt)/ s/^/#DONT/" \
			-i src/apps/CMakeLists.txt \
			|| die "Failed to disable marble-qt"
	fi

	kde5_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package aprs Perl)
		$(cmake-utils_use_find_package positioning Qt5Location)
		$(cmake-utils_use_find_package positioning Qt5Positioning)
		-DBUILD_MARBLE_TESTS=$(usex test)
		-DWITH_DESIGNER_PLUGIN=$(usex designer)
		-DWITH_libgps=$(usex gps)
		-DWITH_KF5=$(usex kde)
		-DWITH_Phonon=$(usex phonon)
		-DWITH_libshp=$(usex shapefile)
		-DWITH_libwlocate=OFF
	)
	kde5_src_configure
}

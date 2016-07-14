# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="forceoptional"
KDE_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Generic geographical map widget"
HOMEPAGE="https://marble.kde.org/"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"

IUSE="aprs designer-plugin gps +kde phonon shapefile"

# FIXME (new packages):
# libwlocate, WLAN-based geolocation
# qextserialport, interface to old fashioned serial ports
RDEPEND="
	$(add_qt_dep qtconcurrent)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtopengl)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtscript)
	$(add_qt_dep qtsql)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwebkit)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	gps? ( >=sci-geosciences/gpsd-2.95 )
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
	shapefile? ( sci-libs/shapelib )
"
DEPEND="${RDEPEND}
	aprs? ( dev-lang/perl )
"

# bug 588320
RESTRICT=test

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package aprs Perl)
		-DBUILD_MARBLE_TESTS=$(usex test)
		-DWITH_DESIGNER_PLUGIN=$(usex designer-plugin)
		-DWITH_libgps=$(usex gps)
		-DWITH_KF5=$(usex kde)
		-DWITH_Phonon=$(usex phonon)
		-DWITH_libshp=$(usex shapefile)
		-DWITH_QextSerialPort=OFF
		-DWITH_liblocation=0
	)
	kde5_src_configure
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional" # see src/apps/marble-kde/CMakeLists.txt
KDE_SUBSLOT="true"
KDE_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Virtual Globe and World Atlas to learn more about Earth"
HOMEPAGE="https://marble.kde.org/"

KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="aprs +dbus designer gps +kde nls phonon +geolocation shapefile +webengine"

# FIXME (new package): libwlocate, WLAN-based geolocation
BDEPEND="
	aprs? ( dev-lang/perl )
	nls? ( $(add_qt_dep linguist-tools) )
"
DEPEND="
	$(add_qt_dep qtconcurrent)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtsql)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	sys-libs/zlib
	aprs? ( $(add_qt_dep qtserialport) )
	dbus? ( $(add_qt_dep qtdbus) )
	designer? ( $(add_qt_dep designer) )
	geolocation? ( $(add_qt_dep qtpositioning) )
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
	phonon? ( media-libs/phonon[qt5(+)] )
	shapefile? ( sci-libs/shapelib:= )
	webengine? ( $(add_qt_dep qtwebengine 'widgets') )
"
RDEPEND="${DEPEND}"

# bug 588320
RESTRICT+=" test"

src_prepare() {
	kde5_src_prepare

	rm -rf src/3rdparty/zlib || die "Failed to remove bundled libs"

	if use kde; then
		sed -e "/add_subdirectory(marble-qt)/ s/^/#DONT/" \
			-i src/apps/CMakeLists.txt || die "Failed to disable marble-qt"
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package aprs Perl)
		$(cmake-utils_use_find_package geolocation Qt5Positioning)
		-DBUILD_MARBLE_TESTS=$(usex test)
		-DWITH_DESIGNER_PLUGIN=$(usex designer)
		-DWITH_libgps=$(usex gps)
		-DWITH_KF5=$(usex kde)
		-DWITH_Phonon4Qt5=$(usex phonon)
		-DWITH_libshp=$(usex shapefile)
		$(cmake-utils_use_find_package webengine Qt5WebEngine)
		$(cmake-utils_use_find_package webengine Qt5WebEngineWidgets)
		-DWITH_libwlocate=OFF
		# bug 608890
		-DKDE_INSTALL_CONFDIR="/etc/xdg"
	)
	if use kde; then
		kde5_src_configure
	else
		cmake-utils_src_configure
	fi
}

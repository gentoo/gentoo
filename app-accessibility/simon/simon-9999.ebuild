# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_BRANCH="kf5"
KDE_HANDBOOK="forceoptional"
KDE_TEST="forceoptional"
inherit kde5

DESCRIPTION="Open-source speech recognition program for replacing mouse and keyboard"
HOMEPAGE="https://simon-listens.org/"
[[ ${PV} != *9999* ]] && SRC_URI="mirror://kde/unstable/simon/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
KEYWORDS=""
IUSE="libsamplerate opencv pim sphinx"

DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep khtml)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep ktexteditor)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_kdeapps_dep okular)
	$(add_qt_dep qtconcurrent)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtsql)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	$(add_qt_dep qtx11extras)
	media-libs/alsa-lib
	media-libs/libqaccessibilityclient:5
	x11-libs/libX11
	x11-libs/libXtst
	x11-libs/qwt:6=[qt5]
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package pim KF5CalendarCore)
		$(cmake-utils_use_find_package pim KF5Akonadi)
		-DWITH_LibSampleRate=$(usex libsamplerate)
		-DWITH_OpenCV=$(usex opencv)
		-DBackendType=$(usex sphinx "both" "jhtk")
		$(cmake-utils_use_find_package sphinx Sphinxbase)
		$(cmake-utils_use_find_package sphinx Pocketsphinx)
		-DQWT_INCLUDE_DIR=/usr/include/qwt6
		-DQWT_LIBRARY=/usr/$(get_libdir)/libqwt6-qt5.so
	)

	kde5_src_configure
}

pkg_postinst() {
	kde5_pkg_postinst

	elog "Optional dependency:"
	use sphinx && elog "  app-accessibility/julius (alternative backend)"
}

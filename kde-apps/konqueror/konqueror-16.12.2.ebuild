# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional" # not optional until !kdelibs4support
KDE_TEST="true"
VIRTUALX_REQUIRED="test"
inherit flag-o-matic kde5

DESCRIPTION="Web browser and file manager based on KDE Frameworks"
HOMEPAGE="
	https://www.kde.org/applications/internet/konqueror/
	https://konqueror.org/
"
KEYWORDS="~amd64 ~x86"
IUSE="activities speech tidy X"
# 4 of 4 tests fail. Last checked for 4.0.3
RESTRICT+=" test"

# drop qtwebengine subslot operator when QT_MINIMAL >= 5.8.0
COMMON_DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kbookmarks)
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kded)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep kdesu)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep khtml)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwebengine 'widgets' '' '5=')
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	sys-libs/zlib
	speech? ( $(add_qt_dep qtspeech) )
	tidy? ( app-text/htmltidy )
	X? ( $(add_qt_dep qtx11extras) )
"
DEPEND="${COMMON_DEPEND}
	activities? ( $(add_frameworks_dep kactivities) )
"
RDEPEND="${COMMON_DEPEND}
	$(add_kdeapps_dep kfind)
	$(add_plasma_dep kde-cli-tools)
	!kde-apps/kfmclient:4
	!kde-apps/konq-plugins
	!kde-apps/libkonq:5
"

src_prepare() {
	[[ ${CHOST} == *-solaris* ]] && append-ldflags -lmalloc

	kde5_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package activities KF5Activities)
		$(cmake-utils_use_find_package speech Qt5TextToSpeech)
		$(cmake-utils_use_find_package tidy LibTidy)
		$(cmake-utils_use_find_package X X11)
	)
	kde5_src_configure
}

pkg_postinst() {
	kde5_pkg_postinst

	if ! has_version kde-apps/keditbookmarks:${SLOT} ; then
		elog "For bookmarks support, install keditbookmarks:"
		elog "kde-apps/keditbookmarks:${SLOT}"
	fi

	if ! has_version kde-apps/dolphin:${SLOT} ; then
		elog "If you want to use konqueror as a filemanager, install the dolphin kpart:"
		elog "kde-apps/dolphin:${SLOT}"
	fi

	if ! has_version kde-apps/svg:${SLOT} ; then
		elog "For konqueror to view SVGs, install the svg kpart:"
		elog "kde-apps/svgpart:${SLOT}"
	fi

	if ! has_version virtual/jre ; then
		elog "To use Java on webpages install virtual/jre."
	fi
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_TEST="optional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Useful applications for Plasma development"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="plasmate"

DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemmodels)
	$(add_frameworks_dep kpackage)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktexteditor)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep plasma)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	plasmate? (
		$(add_frameworks_dep kdelibs4support)
		$(add_frameworks_dep knewstuff)
		$(add_frameworks_dep kparts)
		$(add_qt_dep qtwebkit)
		dev-util/kdevplatform:5
	)
"
RDEPEND="${DEPEND}
	!dev-util/plasmate
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package plasmate KDevPlatform)
		$(cmake-utils_use_find_package plasmate Qt5WebKit)
		$(cmake-utils_use_find_package plasmate Qt5WebKitWidgets)
	)

	kde5_src_configure
}

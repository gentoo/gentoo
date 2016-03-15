# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="true"
KDE_TEST="true"
inherit kde5

DESCRIPTION="Kate is an advanced text editor"
HOMEPAGE="https://www.kde.org/applications/utilities/kate http://kate-editor.org"
KEYWORDS=" ~amd64 ~x86"
IUSE="+addons"

DEPEND="
	$(add_frameworks_dep kactivities)
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemmodels)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktexteditor)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtscript)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	addons? (
		$(add_frameworks_dep kbookmarks)
		$(add_frameworks_dep knewstuff)
		$(add_frameworks_dep kwallet)
		$(add_frameworks_dep plasma)
		$(add_frameworks_dep threadweaver)
		$(add_qt_dep qtsql)
		>=dev-libs/libgit2-0.22.0:=
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_ADDONS=$(usex addons)
		-DBUILD_kwrite=FALSE
		$(cmake-utils_use_find_package handbook KF5DocTools)
	)

	kde5_src_configure
}

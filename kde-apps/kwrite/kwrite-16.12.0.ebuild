# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KMNAME="kate"
KDE_HANDBOOK="true"
inherit kde5

DESCRIPTION="KDE simple text editor"
HOMEPAGE="https://www.kde.org/applications/utilities/kwrite"
KEYWORDS="~amd64 ~x86"

DEPEND="
	$(add_frameworks_dep kactivities)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep ktexteditor)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_addons=FALSE
		-DBUILD_kate=FALSE
		-DBUILD_katepart=FALSE
		$(cmake-utils_use_find_package handbook DocTools)
	)

	kde5_src_configure
}

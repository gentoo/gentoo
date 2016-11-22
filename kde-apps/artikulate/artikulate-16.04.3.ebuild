# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="true"
inherit kde5

DESCRIPTION="Language learning application that helps improving pronunciation skills"
HOMEPAGE="https://edu.kde.org/applications/language/artikulate"
KEYWORDS="amd64 x86"
IUSE="+gstreamer qtmedia"

DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtsql)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	$(add_qt_dep qtxmlpatterns)
	gstreamer? ( >=media-libs/qt-gstreamer-1.2.0[qt5] )
	qtmedia? ( $(add_qt_dep qtmultimedia) )
"
RDEPEND="${DEPEND}"

REQUIRED_USE="|| ( gstreamer qtmedia )"

src_configure() {
	local mycmakeargs=(
		-DBUILD_GSTREAMER_PLUGIN=$(usex gstreamer)
		-DBUILD_QTMULTIMEDIA_PLUGIN=$(usex qtmedia)
	)

	kde5_src_configure
}

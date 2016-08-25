# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="MathML-based graph calculator by KDE"
HOMEPAGE="https://www.kde.org/applications/education/kalgebra
https://edu.kde.org/kalgebra"
KEYWORDS="amd64 x86"
IUSE="opengl readline"

DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_kdeapps_dep analitza 'opengl?')
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwebkit)
	$(add_qt_dep qtwidgets)
	opengl? (
		$(add_qt_dep qtopengl)
		$(add_qt_dep qtprintsupport)
		virtual/glu
	)
	readline? ( sys-libs/readline:0= )
"
RDEPEND="${DEPEND}
	!kde-apps/analitza:4
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package opengl OpenGL)
		$(cmake-utils_use_find_package readline Readline)
	)

	kde5_src_configure
}

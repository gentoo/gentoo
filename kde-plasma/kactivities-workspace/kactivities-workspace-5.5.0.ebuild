# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5

DESCRIPTION="Transitional package for activities KCM and KIO modules in Plasma-5.5"
SRC_URI="mirror://kde/stable/kactivities/${P}.tar.xz"

LICENSE="|| ( GPL-2 GPL-3 )"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

COMMON_DEPEND="
	$(add_frameworks_dep kactivities)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kglobalaccel)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtsql)
	$(add_qt_dep qtwidgets)
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/boost-1.54
"
RDEPEND="${COMMON_DEPEND}
	!>kde-apps/kio-extras-15.12.50
	!<kde-base/kactivities-4.13.3-r1:4[-minimal(-)]
	!kde-base/kactivitymanagerd
	!<kde-frameworks/kactivities-5.20.0
	!>kde-plasma/plasma-desktop-5.5.90
"

src_prepare() {
	kde5_src_prepare
	# Remove conflict with kde-frameworks/kactivities
	sed -e "/add_subdirectory.*imports/ s/^/#DONT/" \
		-i src/workspace/CMakeLists.txt || die
}

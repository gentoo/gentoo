# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="true"
inherit kde5

DESCRIPTION="Paint Program by KDE"
HOMEPAGE="https://www.kde.org/applications/graphics/kolourpaint/"
KEYWORDS="~amd64 ~x86"
LICENSE="BSD-2 LGPL-2 LGPL-2+ || ( LGPL-2.1 LGPL-3 ) GPL-2 handbook? ( FDL-1.2 )"
IUSE="scanner"

RDEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtwidgets)
	scanner? ( $(add_kdeapps_dep libksane) )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package scanner KF5Sane)
	)

	kde5_src_configure
}

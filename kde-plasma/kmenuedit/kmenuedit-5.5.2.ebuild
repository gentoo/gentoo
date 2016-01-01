# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="true"
inherit kde5

DESCRIPTION="KDE menu editor"
HOMEPAGE="https://projects.kde.org/projects/kde/workspace/kmenuedit"
KEYWORDS="~amd64 ~x86"
IUSE="+hotkeys"

DEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep sonnet)
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	hotkeys? ( $(add_plasma_dep khotkeys) )
"
RDEPEND="${DEPEND}
	!kde-base/kmenuedit:4
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package hotkeys KHotKeysDBusInterface)
	)

	kde5_src_configure
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_TEST="forceoptional"
inherit kde5

DESCRIPTION="KDE Plasma screen management"
HOMEPAGE="https://projects.kde.org/projects/extragear/base/kscreen"

KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kglobalaccel)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_plasma_dep libkscreen)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative 'widgets')
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
"
RDEPEND="${DEPEND}
	$(add_plasma_dep kde-cli-tools)
	$(add_qt_dep qtgraphicaleffects)
	!kde-misc/kscreen
"

# bug #580440, last checked 5.6.3
RESTRICT+=" test"

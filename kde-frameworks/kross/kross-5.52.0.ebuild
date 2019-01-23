# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
KDE_QTHELP="false"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Framework for embedding scripting into applications"
LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm ~x86"
IUSE=""

RDEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtscript)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
"
DEPEND="${RDEPEND}
	$(add_qt_dep designer)
"

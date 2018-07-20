# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_QTHELP="false"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Framework providing a common interface for KParts that can play media files"
LICENSE="MIT"
KEYWORDS="amd64 ~arm x86"
IUSE=""

RDEPEND="
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtwidgets)
"
DEPEND="${RDEPEND}"

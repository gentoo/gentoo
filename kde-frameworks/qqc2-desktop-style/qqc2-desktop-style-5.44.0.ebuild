# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_QTHELP="false"
inherit kde5

DESCRIPTION="Style for QtQuickControls 2 that uses QWidget's QStyle for painting"
KEYWORDS="~amd64 ~arm ~x86"
LICENSE="|| ( GPL-2+ LGPL-3+ )"
IUSE=""

# drop qtdeclarative subslot operator when QT_MINIMAL >= 5.8.0
DEPEND="
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kirigami)
	$(add_qt_dep qtdeclarative '' '' '5=')
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
"
RDEPEND="${DEPEND}
	$(add_qt_dep qtgraphicaleffects)
	$(add_qt_dep qtquickcontrols2)
"

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5

DESCRIPTION="Framework for working with KDE activities"
LICENSE="|| ( LGPL-2.1 LGPL-3 )"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

COMMON_DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative widgets)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtsql)
"
RDEPEND="${COMMON_DEPEND}
	$(add_plasma_dep kactivitymanagerd)
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/boost-1.54
"

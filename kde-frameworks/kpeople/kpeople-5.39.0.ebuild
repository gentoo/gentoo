# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="KDE contact person abstraction library"
HOMEPAGE="https://projects.kde.org/projects/frameworks/kpeople"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtsql)
	$(add_qt_dep qtwidgets)
"
RDEPEND="${DEPEND}
	!net-libs/kpeople:5
"

src_test() {
	# bug: 612504
	local myctestargs=( -j1 )

	kde5_src_test
}

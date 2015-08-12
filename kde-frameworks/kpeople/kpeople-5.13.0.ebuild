# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde5

DESCRIPTION="KDE contact person abstraction library"
HOMEPAGE="https://projects.kde.org/projects/frameworks/kpeople"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtsql:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}
	!net-libs/kpeople:5
	!net-libs/libkpeople[-minimal(-)]
"

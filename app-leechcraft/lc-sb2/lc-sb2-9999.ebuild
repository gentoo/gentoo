# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit leechcraft

DESCRIPTION="Sidebar for LeechCraft supporting quarks like tab switcher, tray area and so on"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtdeclarative:5[widgets]
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
"
RDEPEND="${DEPEND}"

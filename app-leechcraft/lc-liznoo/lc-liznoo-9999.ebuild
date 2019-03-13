# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit leechcraft

DESCRIPTION="UPower-based power manager for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	x11-libs/qwt:6
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtdbus:5
	dev-qt/qtconcurrent:5
"
RDEPEND="${DEPEND}
	~virtual/leechcraft-trayarea-${PV}
	sys-power/upower"

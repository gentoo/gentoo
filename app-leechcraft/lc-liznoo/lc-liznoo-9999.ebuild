# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit leechcraft

DESCRIPTION="UPower-based power manager for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="+battery debug +poweractions +powerevents"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtconcurrent:5
	dev-qt/qtdbus:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	x11-libs/qwt:6
"
RDEPEND="${DEPEND}
	~virtual/leechcraft-trayarea-${PV}
	battery? ( sys-power/upower )
	poweractions? ( sys-power/upower )
	powerevents? ( || ( sys-auth/consolekit sys-auth/elogind sys-power/upower ) )
"

REQUIRED_USE="|| ( battery poweractions powerevents )"

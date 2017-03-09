# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit leechcraft

DESCRIPTION="The LeechCraft notification daemon"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtnetwork:5
	dev-qt/qtgui:5
	dev-qt/qtdbus:5
	"
RDEPEND="${DEPEND}
	~virtual/leechcraft-notifier-${PV}"

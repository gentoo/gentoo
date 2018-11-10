# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit leechcraft toolchain-funcs

DESCRIPTION="Allows launching external applications (and LeechCraft plugins) from LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtnetwork:5
	dev-qt/qtgui:5
	dev-qt/qtdeclarative:5[widgets]
"
RDEPEND="${DEPEND}
	~virtual/leechcraft-trayarea-${PV}"

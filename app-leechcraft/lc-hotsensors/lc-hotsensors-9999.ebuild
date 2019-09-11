# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit leechcraft

DESCRIPTION="Temperature sensors monitor plugin for LeechCraft"

# We should define license for this plugin explicitly
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}[qwt]
	sys-apps/lm-sensors
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtdeclarative:5[widgets]
"
RDEPEND="${DEPEND}
	~virtual/leechcraft-quark-sideprovider-${PV}"

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit leechcraft

DESCRIPTION="Temperature sensors monitor plugin for LeechCraft"

# We should define license for this plugin explicitly
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}[qwt]
	dev-qt/qtdeclarative:5[widgets]
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	sys-apps/lm-sensors:=
"
RDEPEND="${DEPEND}
	~virtual/leechcraft-quark-sideprovider-${PV}"

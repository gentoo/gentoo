# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit leechcraft

DESCRIPTION="Glance, quick thumbnailed overview of opened tabs in LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}"

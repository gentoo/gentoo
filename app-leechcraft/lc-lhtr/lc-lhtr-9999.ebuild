# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit leechcraft

DESCRIPTION="LeechCraft HTML Text editoR component"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	app-text/tidy-html5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtwebkit:5
"
RDEPEND="${DEPEND}"

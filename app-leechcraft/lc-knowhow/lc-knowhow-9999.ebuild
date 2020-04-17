# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit leechcraft

DESCRIPTION="KnowHow, plugin for showing Tips of the Day in LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
"
RDEPEND="${DEPEND}"

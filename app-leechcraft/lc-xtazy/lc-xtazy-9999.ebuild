# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit leechcraft

DESCRIPTION="Fetches info about current tune and provides it to other plugins"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
		dev-qt/qtdbus:4"
RDEPEND="${DEPEND}"

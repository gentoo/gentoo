# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit leechcraft

DESCRIPTION="Summary plugin for Leechcraft"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}"

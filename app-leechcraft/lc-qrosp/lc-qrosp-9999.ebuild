# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit leechcraft

DESCRIPTION="Qrosp, scrpting support for LeechCraft via Qross"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	>=dev-libs/qrosscore-0.3.2"
RDEPEND="${DEPEND}"

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-xtazy/lc-xtazy-0.6.60.ebuild,v 1.3 2014/04/03 08:05:45 zlogene Exp $

EAPI="5"

inherit leechcraft

DESCRIPTION="Fetches info about current tune and provides it to other plugins"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
		dev-qt/qtdbus:4"
RDEPEND="${DEPEND}"

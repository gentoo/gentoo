# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit leechcraft

DESCRIPTION="Provides plugin- or tab-grained keyboard layout control"

SLOT="0"
KEYWORDS=""
IUSE="debug quark"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtdeclarative:5[widgets]
"
RDEPEND="${DEPEND}
	x11-apps/setxkbmap
	quark? ( ~virtual/leechcraft-quark-sideprovider-${PV} )"

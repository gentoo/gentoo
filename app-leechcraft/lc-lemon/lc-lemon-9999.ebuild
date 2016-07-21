# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit leechcraft

DESCRIPTION="Network monitor plugin for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	~virtual/leechcraft-quark-sideprovider-${PV}
	dev-qt/qtbearer:4
	dev-qt/qtdeclarative:4
	dev-libs/libnl:3
	x11-libs/qwt:6
	"
RDEPEND="${DEPEND}"

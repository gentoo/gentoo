# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-lemon/lc-lemon-9999.ebuild,v 1.1 2013/03/08 22:01:10 maksbotan Exp $

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

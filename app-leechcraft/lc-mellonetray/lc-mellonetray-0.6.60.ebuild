# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-mellonetray/lc-mellonetray-0.6.60.ebuild,v 1.3 2014/04/03 08:32:54 zlogene Exp $

EAPI="5"

inherit leechcraft

DESCRIPTION="System tray quark for LeechCraft"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtdeclarative:4
	x11-libs/libXdamage
	x11-libs/libXrender"
RDEPEND="${DEPEND}
	 ~virtual/leechcraft-quark-sideprovider-${PV}"

# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-sysnotify/lc-sysnotify-9999.ebuild,v 1.1 2013/05/24 15:23:51 pinkbyte Exp $

EAPI="5"

inherit leechcraft

DESCRIPTION="Notifications via system libnotify daemon for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtdbus:4"
RDEPEND="${DEPEND}"

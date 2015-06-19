# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-certmgr/lc-certmgr-9999.ebuild,v 1.1 2014/03/23 14:42:19 maksbotan Exp $

EAPI="5"

inherit leechcraft

DESCRIPTION="SSL certificates manager for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}"
RDEPEND="${DEPEND}"
